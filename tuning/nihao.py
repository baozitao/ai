import pygame
import random

# 初始化 Pygame 库
pygame.init()

# 定义常量
SCREEN_WIDTH = 640
SCREEN_HEIGHT = 480
CELL_SIZE = 20
FPS = 10

# 定义颜色
BLACK = (0, 0, 0)
WHITE = (255, 255, 255)
RED = (255, 0, 0)
GREEN = (0, 255, 0)

# 创建游戏窗口
screen = pygame.display.set_mode((SCREEN_WIDTH, SCREEN_HEIGHT))
pygame.display.set_caption('Snake Game')

# 定义贪吃蛇类
class Snake:
    def __init__(self):
        self.body = [(SCREEN_WIDTH // 2, SCREEN_HEIGHT // 2)]
        self.direction = 'right'
        
    def move(self):
        x, y = self.body[0]
        if self.direction == 'up':
            y -= CELL_SIZE
        elif self.direction == 'down':
            y += CELL_SIZE
        elif self.direction == 'left':
            x -= CELL_SIZE
        elif self.direction == 'right':
            x += CELL_SIZE
        self.body.insert(0, (x, y))
        self.body.pop()
        
    def grow(self):
        x, y = self.body[0]
        if self.direction == 'up':
            y -= CELL_SIZE
        elif self.direction == 'down':
            y += CELL_SIZE
        elif self.direction == 'left':
            x -= CELL_SIZE
        elif self.direction == 'right':
            x += CELL_SIZE
        self.body.insert(0, (x, y))
        
    def draw(self):
        for x, y in self.body:
            pygame.draw.rect(screen, GREEN, (x, y, CELL_SIZE, CELL_SIZE))
            
    def check_collision(self):
        x, y = self.body[0]
        if x < 0 or x >= SCREEN_WIDTH or y < 0 or y >= SCREEN_HEIGHT:
            return True
        for i in range(1, len(self.body)):
            if x == self.body[i][0] and y == self.body[i][1]:
                return True
        return False

# 定义食物类
class Food:
    def __init__(self):
        self.x = random.randint(0, SCREEN_WIDTH // CELL_SIZE - 1) * CELL_SIZE
        self.y = random.randint(0, SCREEN_HEIGHT // CELL_SIZE - 1) * CELL_SIZE
        
    def draw(self):
        pygame.draw.rect(screen, RED, (self.x, self.y, CELL_SIZE, CELL_SIZE))

# 创建贪吃蛇和食物对象
snake = Snake()
food = Food()

# 创建时钟对象
clock = pygame.time.Clock()

# 游戏循环
while True:
    # 处理事件
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            pygame.quit()
            quit()
        elif event.type == pygame.KEYDOWN:
            if event.key == pygame.K_UP and snake.direction != 'down':
                snake.direction = 'up'
            elif event.key == pygame.K_DOWN and snake.direction != 'up':
                snake.direction = 'down'
            elif event.key == pygame.K_LEFT and snake.direction != 'right':
                snake.direction = 'left'
            elif event.key == pygame.K_RIGHT and snake.direction != 'left':
                snake.direction = 'right'
    
    # 移动贪吃蛇
    snake.move()
    
    # 检查是否吃到食物
    if snake.body[0][0] == food.x and snake.body[0][1] == food.y:
        snake.grow()
        food = Food()
        
    # 检查是否撞墙或撞到自己
    if snake.check_collision():
        pygame.quit()
        quit()
    
    # 绘制游戏界面
    screen.fill(BLACK)
    snake.draw()
    food.draw()
    pygame.display.update()
    
    # 控制帧率
    clock.tick(FPS)