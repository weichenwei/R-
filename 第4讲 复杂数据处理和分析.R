#2017-07-09 PM 15：25
                     #航班航行距离与延误时间的关系？

#1.如何编写函数
#2.数据处理: dpylr, ggplot2
#3.如何编写业务模块
#4.代码如何调试

         #自定义编写函数例子

#add是名称代表功能，函数function(x, y)代表输入，return(z)代表输出
#编译函数
add <- function(x, y){
  z <- x + y
  return(z)
}

#使用函数
a <- add(1, 2)
a #a等于3

         #编写函数的模板

#1. my_fun的名称是功能， 2. (arg1, arg2)是输入, 3. (data)是输入
my_fun <- function(arg1, arg2){
  body  #实现具体业务逻辑的代码
  return(data)
}

#函数定义好后，必须编译才能使用，方法同运行代码一样。

#          > 循环语句           
#控制语句
#          > 条件语句


       #for循环语句

#重复性工作
print(str_c("第几次吃饭:", 1, sep = ""))
print(str_c("第几次吃饭:", 2, sep = ""))
print(str_c("第几次吃饭:", 3, sep = ""))

#用循环语句替代重复性工作
data <- c(1, 2, 3)

for(i in data){
  print(str_c("第几次吃饭", i, sep = ""))
}

#for循环模板
for(i in data){
  body
}

   
     #while循环语句

#模板
while(condition){
  body
}
#例子，条件语句不为正时停止；
#写循环语句一定要有循环结束的条件，否则循环会一直不停的进行下去。
i <- 10
while(i > 0){
  i <- i-1
}


      #条件语句

#模板
if(condition){
  body
} else{
  body
}

#例子
#你的钱包有多少钱
money <- 100

if(money > 0){
  money <- money -30  #吃饭花了30元
  print("钱包还有钱，不需要取钱")
} else{
  print("钱包没有钱，去取款机吧")
}


            #案例: 业务需求

#王思聪饭卡1000元，每天吃3次饭，每顿饭花掉5元，饭卡余额<5元时，提示.
#周星驰饭卡1000元，每天吃2次饭，每顿饭花掉5元，饭卡余额<5元时，提示.

#定义函数
#功能：每天吃饭
#输入参数：eat吃饭次数，money公司第一次给员工饭卡的钱
#输出：给员工提示是否该去银行取钱

library(stringr)
everyday <- function(eat, money){
  for(i in eat){
    eatNumber <- str_c("今天吃了第几次饭:", i, sep = "")
    money <- money - 5  #每顿饭消费掉5元
    print(eatNumber)
  }
  if(money < 5){  #饭卡余额<5元，提示
    print("钱包没钱了: 去银行取点钱话")
  } else{
    print("钱包还有钱: 不用去银行")
  } 
}
everyday(3, 1000)


#2017-07-10

#数据预分析步骤
 #1.理解数据；2.数据导入；3.数据预处理；4。数据计算；5.数据显示

        #理解数据：航班数据
#数据处理包
#install.packages("dplyr")
#数据包
#install.packages("nycflights13")

library(dplyr)
library(nycflights13)  #for data

flights

   #数据预处理步骤
#1.选择子集；2.列名重命名；3.删除缺失数据
#4.处理日期；5.数据类型转换；6.数据排列

    #1.选择子集

#确定分析目标：航班航行距离与延误时间的关系

#字段名：year, month, day, dep_delay, arr_delay, distance, dest

#选择子集select
myFlights <- select(flights,
                    year, month, day,
                    dep_delay, arr_delay,
                    distance, dest)
myFlights

#例子1：
select(flights, year:day)

#例子2：
select(flights, -(year:day))

#例子3：模糊查询 (忘记了某些列名的名字)
#1)starts_with("abc")  以abc开头的列名
#2)ends_with("xyz")   以xyz结尾的列名
#3)contains("ijk")   包含ijk字段的
#4)matches("(.)\\1")   正则表达式

myFlights <- select(flights,
                    year:day,
                    ends_with("delay"),
                    distance,
                    dest)
myFlights

    #2.列名重命名

myFlights <- rename(myFlights, destination = dest)

#dplyr包查找数据
#filter()

    #3.删除缺失数据

myFlights <- filter(myFlights,
                    !is.na(dep_delay),
                    !is.na(arr_delay))
#处理前336,776
#处理后327,346
#缺少值8255

#查找数据例子 （熟悉10个逻辑运算符）

#例子1：查找12月25日的航班
filter(myFlights, month ==12, day ==25)

#例子2：延误时间大于2小时的航班
filter(myFlights,
       arr_delay > 120 | dep_delay > 120)


    #dplyr包数据排序
    #arrange()

#默认：升序
arrange(myFlights, dep_delay)

#desc降序：descending
arrange(myFlights, desc(dep_delay))

#数据预处理结束


        #数据计算

#dplyr包: 数据计算
#1) 分组函数group_by()
#2) 组合函数summarise()

#数据处理模式：Split(数据分组) -> Apply(应用函数) -> Combine(组合结果)

#分析目标：航班航行距离与到达延误时间的关系

#1.Split:数据分组 (group_by函数)
by_dest <- group_by(myFlights, destination)

#2.Apply应用函数 + Combine组合结果: (summarise函数)
delay <- summarise(by_dest,
                   count = n(),  #航班数
                   dist = mean(distance, na.rm = TRUE),
                   delay = mean(arr_delay, na.rm = TRUE)
                   )

  #移除噪音数据 （移除数据量比较少的数据，下例中，移除数据量少于20的数据）
delay <- filter(delay, count > 20)

  #管道: %>%
#将上一个函数运行的结果作为下一个函数的输入
#管道符号左边连接的是输入数据，右边的函数要使用左边的输出结果来进行计算
delays <- flights %>%
  group_by(dest) %>%
  summarise(
    count = n(),
    dist = mean(distance, na.rm = TRUE),
    delay = mean(arr_delay, na.rm = TRUE)
    ) %>%
  filter(count >20)

        #数据显示

#数据显示绘图包: ggplot2
library(ggplot2)

ggplot(data = delay) +
  geom_point(mapping = aes(x = dist, y = delay)) +
  geom_smooth(mapping = aes(x = dist, y = delay))   #geo_smooth:平滑曲线

#aes: aesthetic美学的
#geo_smooth: 平滑曲线

#ggplot2: 绘图模板
ggplot(data = <DATA>) +  #创建画板
  <GEOM_FUNCTION>(mapping = aes(<MAPPINGS>))  #添加图层


#2017-07-11

        #3. 如何编写业务模块

#项目：模块化(视图模块view, 业务逻辑模块service, 数据层模块db)


#2017-07-12
                #各个模块下的R脚本如何调用？

library(dplyr)
library(ggplot2)
library(stringr)

    #视图模块：view/flightView.R

#1.定义好R路径
  #当前项目运行根路径
projectPath <- getwd()  #例如：D:/RworkSpace/da
#service路径
servicePath <- str_c(projectPath,
                     "service",
                     sep = "/")

#2.导入业务逻辑中的R文件
  #编译R文件
source(str_c(servicePath, "flight.R", sep = "/"))

#3.使用业务逻辑中的方法
  #业务逻辑：航班航行距离与延误时间的关系
delay <- disDelay()

list(
  first = 1
  second = 2
)
















