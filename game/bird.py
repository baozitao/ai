import pygame
import random

# 初始化pygame
pygame.init()

# 颜色定义
WHITE = (255, 255, 255)
GREEN = (0, 255, 0)
RED = (255, 0, 0)
BLUE = (0, 0, 255)

# 屏幕尺寸
SCREEN_WIDTH = 640
SCREEN_HEIGHT = 480
BLOCK_SIZE = 20

class Snake:
    def __init__(self):
        self.positions = [(5, 5), (4, 5), (3, 5)]
        self.direction = (1, 0)
        self.grow = False

    def move(self):
        head = self.positions[0]
        new_head = ((head[0] + self.direction[0]) % (SCREEN_WIDTH // BLOCK_SIZE),
                    (head[1] + self.direction[1]) % (SCREEN_HEIGHT // BLOCK_SIZE))
        self.positions = [new_head] + self.positions[:-1]
        if self.grow:
            self.positions.append(self.positions[-1])
            self.grow = False

    def eat(self, food):
        if self.positions[0] == food.position:
            self.grow = True
            return True
        return False

    def collide(self):
        return self.positions[0] in self.positions[1:]

    def draw(self, screen):
        for segment in self.positions:
            pygame.draw.rect(screen, GREEN, (segment[0]*BLOCK_SIZE, segment[1]*BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE))

class Food:
    def __init__(self):
        self.position = (random.randint(0, (SCREEN_WIDTH // BLOCK_SIZE) - 1),
                         random.randint(0, (SCREEN_HEIGHT // BLOCK_SIZE) - 1))
        self.is_food_on_screen = True

    def draw(self, screen):
        pygame.draw.rect(screen, RED, (self.position[0]*BLOCK_SIZE, self.position[1]*BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE))

    def randomize_position(self):
        self.position = (random.randint(0, (SCREEN_WIDTH // BLOCK_SIZE) - 1),
                         random.randint(0, (SCREEN_HEIGHT // BLOCK_SIZE) - 1))

def main():
    screen = pygame.display.set_mode((SCREEN_WIDTH, SCREEN_HEIGHT))
    pygame.display.set_caption("Snake Game")

    snake = Snake()
    food = Food()

    clock = pygame.time.Clock()

    running = True
    while running:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running = False
            if event.type == pygame.KEYDOWN:
                if event.key == pygame.K_UP and snake.direction != (0, 1):
                    snake.direction = (0, -1)
                if event.key == pygame.K_DOWN and snake.direction != (0, -1):
                    snake.direction = (0, 1)
                if event.key == pygame.K_LEFT and snake.direction != (1, 0):
                    snake.direction = (-1, 0)
                if event.key == pygame.K_RIGHT and snake.direction != (-1, 0):
                    snake.direction = (1, 0)

        snake.move()
        if snake.eat(food):
            food.randomize_position()
        if snake.collide():
            running = False

        screen.fill(BLUE)
        snake.draw(screen)
        food.draw(screen)
        pygame.display.flip()

        clock.tick(10)

    pygame.quit()

if __name__ == "__main__":
    main()