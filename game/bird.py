import pygame
import sys

# Game variables
gravity = 0.25
bird_movement = 0
game_active = True

# Pygame initialization
pygame.init()
screen = pygame.display.set_mode((288, 512))

# Clock
clock = pygame.time.Clock()

# Game Images
bg_surface = pygame.image.load('assets/background-night.png').convert()
floor_surface = pygame.image.load('assets/base.png').convert()
bird_surface = pygame.image.load('assets/bluebird-midflap.png').convert()
bird_rect = bird_surface.get_rect(center = (50, 256))

floor_x_pos = 0

def draw_floor():
    screen.blit(floor_surface, (floor_x_pos, 450))
    screen.blit(floor_surface, (floor_x_pos + 288, 450))

def check_collision(bird_rect):
    global game_active
    if bird_rect.top <= -50 or bird_rect.bottom >= 450:
        game_active = False

while True:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            pygame.quit()
            sys.exit()
        if event.type == pygame.KEYDOWN:
            if event.key == pygame.K_SPACE and game_active:
                bird_movement = 0
                bird_movement -= 6
            if event.key == pygame.K_SPACE and game_active == False:
                game_active = True
                bird_rect.center = (50, 256)
                bird_movement = 0

    screen.blit(bg_surface, (0, 0))

    if game_active:
        bird_movement += gravity
        rotated_bird = bird_surface
        bird_rect.centery += bird_movement
        screen.blit(rotated_bird, bird_rect)
        game_active = check_collision(bird_rect)

    # Floor
    floor_x_pos -= 1
    draw_floor()
    if floor_x_pos <= -288:
        floor_x_pos = 0

    pygame.display.update()
    clock.tick(120)