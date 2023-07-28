import dmPython as dm

# 连接到本地的达梦数据库
conn = dm.connect('SYSDBA', 'SYSDBA', '127.0.0.1', 5236)

# 获取游标对象
cursor = conn.cursor()

# 查询PRODUCT表的NAME、AUTHOR、NOWPRICE三个列的内容
# cursor.execute("SELECT NAME, AUTHOR, NOWPRICE FROM PRODUCTION.PRODUCT")

# 查询PRODUCT表的NAME、AUTHOR、NOWPRICE三个列的内容
cursor.execute("SELECT * FROM PURCHASING.VENDOR")


# 获取查询结果
result = cursor.fetchall()

# 输出查询结果
for r in result:
    print(r)

# 查询PRODUCT表的NAME、AUTHOR、NOWPRICE三个列的内容
# cursor.execute("INSERT INTO PURCHASING.VENDOR(ACCOUNTNO, NAME, ACTIVEFLAG, WEBURL, CREDIT) VALUES ('00', '华中科技大学出版社', 1, '', 2);")

# 关闭连接
conn.close()