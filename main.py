from datetime import time
from pyswip import Prolog
import re
# path = '/home/pavel/PycharmProjects/Saper/input.txt'
# path2 = "/home/pavel/PycharmProjects/Saper/output.txt"
# x = 10
# y = 9
# mines = 12
# queryString = f"info({x},{y},{mines}), minesweeper({x},{y}), mines({mines})."
# prolog = Prolog()
# prolog.consult("minesweeper.pl")
# prolog.consult("play.pl")
# #prolog.consult("test.pl")
#
# #for sol in prolog.query("load_file('/home/pavel/PycharmProjects/Saper/input.txt')"):
# #    print(sol)
# for soln in prolog.query(queryString):
#     print(soln)
# #print(prolog.query("main"))
from tkinter import *
from random import choice


class Pole(object):  # создаем Класс поля, наследуемся от Object
    def __init__(self, master, row, column):  # Инициализация поля. master - окно Tk().
        self.button = Button(master, text='   ')  # Создаем для нашего поля атрибут 'button'
        self.mine = False  # Переменная наличия мины в поле
        self.value = 0  # Кол-во мин вокруг
        self.viewed = False  # Открыто/закрыто поле
        self.flag = 0  # 0 - флага нет, 1 - флаг стоит, 2 - стоит "?"
        self.around = []  # Массив, содержащий координаты соседних клеток
        self.clr = 'black'  # Цвет текста
        self.bg = "darkgrey"  # Цвет фона
        self.row = row  # Строка
        self.column = column  # Столбец

    def viewAround(self):
        return self.around

    def setAround(self):
        if self.row == 0:
            self.around.append([self.row + 1, self.column])
            if self.column == 0:
                self.around.append([self.row, self.column + 1])
                self.around.append([self.row + 1, self.column + 1])
            elif self.column == len(buttons[self.row]) - 1:
                self.around.append([self.row, self.column - 1])
                self.around.append([self.row + 1, self.column - 1])
            else:
                self.around.append([self.row, self.column - 1])
                self.around.append([self.row, self.column + 1])
                self.around.append([self.row + 1, self.column + 1])
                self.around.append([self.row + 1, self.column - 1])
        elif self.row == len(buttons) - 1:
            self.around.append([self.row - 1, self.column])
            if self.column == 0:
                self.around.append([self.row, self.column + 1])
                self.around.append([self.row - 1, self.column + 1])
            elif self.column == len(buttons[self.row]) - 1:
                self.around.append([self.row, self.column - 1])
                self.around.append([self.row - 1, self.column - 1])
            else:
                self.around.append([self.row, self.column - 1])
                self.around.append([self.row, self.column + 1])
                self.around.append([self.row - 1, self.column + 1])
                self.around.append([self.row - 1, self.column - 1])
        else:
            self.around.append([self.row - 1, self.column])
            self.around.append([self.row + 1, self.column])
            if self.column == 0:
                self.around.append([self.row, self.column + 1])
                self.around.append([self.row + 1, self.column + 1])
                self.around.append([self.row - 1, self.column + 1])
            elif self.column == len(buttons[self.row]) - 1:
                self.around.append([self.row, self.column - 1])
                self.around.append([self.row + 1, self.column - 1])
                self.around.append([self.row - 1, self.column - 1])
            else:
                self.around.append([self.row, self.column - 1])
                self.around.append([self.row, self.column + 1])
                self.around.append([self.row + 1, self.column + 1])
                self.around.append([self.row + 1, self.column - 1])
                self.around.append([self.row - 1, self.column + 1])
                self.around.append([self.row - 1, self.column - 1])

    def view(self, event):
        if not mines:  # При первом нажатии
            setMines()  # Устанавливаем мины
        if self.value == 0:  # Устанавливаем цвета. Можно написать и для 6,7 и 8, но у меня закончилась фантазия
            self.clr = 'yellow'
            self.value = None
            self.bg = 'darkgrey'
        elif self.value == 1:
            self.clr = 'green'
        elif self.value == 2:
            self.clr = 'blue'
        elif self.value == 3:
            self.clr = 'red'
        elif self.value == 4:
            self.clr = 'purple'
        print(mines)
        print(flags)
        if self.mine and not self.viewed and not self.flag:  # Если в клетке есть мина, она еще не открыта и на ней нет флага
            self.button.configure(text='💣', bg='red')  # Показываем пользователю, что тут есть мина
            self.viewed = True  # Говорим, что клетка раскрыта
            # for q in mines:
            #     buttons[q[0]][q[1]].view('<Button-1>')  # Я сейчас буду вскрывать ВСЕ мины
            lose()  # Вызываем окно проигрыша

        elif not self.viewed and not self.flag:  # Если мины нет, клетка не открыта и флаг не стоит
            self.button.configure(text=self.value, fg=self.clr, bg=self.bg)  # выводим в текст поля значение
            self.viewed = True
            if self.value == None:  # Если вокруг нет мин
                for k in self.around:
                    buttons[k[0]][k[1]].view('<Button-1>')  # Открываем все поля вокруг

    def setFlag(self, event):
        if self.flag == 0 and not self.viewed:  # Если поле не открыто и флага нет
            self.flag = 1  # Ставим флаг
            self.button.configure(text='🚩', bg='yellow')  # Выводим флаг
            flags.append(self.row)  # Добавляем в массив флагов
            flags.append(self.column)
        elif self.flag == 1:  # Если флаг стоим
            self.flag = 2  # Ставим значение '?'
            self.button.configure(text='?', bg='blue')  # Выводим его
            flags.pop(flags.index(self.row))  # Удаляем флаг из массива флагов
            flags.pop(flags.index(self.column))
        elif self.flag == 2:  # Если вопрос
            self.flag = 0  # Устанавливаем на отсутствие флага
            self.button.configure(text='   ', bg='white')  # Выводим пустоту
        if sorted(mines) == sorted(flags) and mines != []:  # если массив флагов идентичен массиву мин
            winer()  # Сообщаем о победе
        print(mines)
        print(flags)


def bombParser():  # оставляет координаты мин
    fileBomb = open("output2.txt", "r")
    outputBombs = open("outputBombs.txt", "w")
    # считываем все строки
    lines = fileBomb.readlines()
    for j in range((len(lines)) - 2):
        # s1 = "".join(c for c in line if line.isdecimal())
        s1 = re.findall(r'\d+', lines[j])
        s1 = [int(i) for i in s1]
        outputBombs.write(str(s1))
    # закрываем файл
    fileBomb.close()
    outputBombs.close()
    outputBombs = open("outputBombs.txt", "r")
    lines = outputBombs.readlines()
    for line in lines:
        resline = line.replace(",", "")
        resline = resline.replace("[", " ")
        resline = resline.replace("]", " ")
        resline = resline.replace("  ", " ")
        resline = resline.replace("  ", " ")
        resline = resline.strip()
        resline = resline.split(" ")
        for i in range(len(resline)):
            t = int(resline[i])
            mines.append(t)
        print(mines)
        # print(mines)
        # fileBomb = open("output2.txt", "w")
        # fileBomb.write(resline)
        # fileBomb.close()


def setMines():  # Получаем массив полей вокруг и координаты нажатого поля
    queryString = f"tell('{outputPath2}')."  # Открытие output2.txt на запись
    for soln in prolog.query(queryString):
        print(soln)
    queryString = f"info({lenght - 1}, {high - 1}, {bombs + 1}), minesweeper({lenght - 1}, {high - 1}), mines({bombs + 1}), print_store, told."  # Запрос на рандомизацию мин
    for soln in prolog.query(queryString):
        print(soln)
    bombParser()
    setter()


def setter():  # устанавливаем бомбы в класс
    for i in buttons:  # Шагаем по строкам
        for j in i:  # Шагаем по полям в строке i
            for k in range(0, len(mines) - 1, 2):
                if (j.row == mines[k]) and (j.column == mines[k + 1]):
                    j.mine = True
                    print(j.row, j.column)
    for i in buttons:  # Шагаем по строкам
        for j in i:  # Шагаем по полям в строке i
            for k in j.around:  # Шагаем по полям вокруг выбранного поля j
                if buttons[k[0]][k[1]].mine:  # Если в одном из полей k мина
                    buttons[buttons.index(i)][i.index(j)].value += 1  # То увеличиваем значение поля j
    return


def lose():
    loseWindow = Tk()
    loseWindow.title('Вы проиграли:-(')
    loseWindow.geometry('300x100')
    loseLabe = Label(loseWindow, text='В следующий раз повезет больше!')
    loseLabe.pack()
    mines = []
    loseWindow.mainloop()


def winer():
    winWindow = Tk()
    winWindow.geometry('300x100')
    winWindow.title('Вы победили!')
    winLabe = Label(winWindow, text='Поздравляем!')
    winLabe.pack()
    winWindow.mainloop()


def cheat(event):
    for t in mines:
        buttons[t[0]][t[1]].setFlag('<Button-1>')


def game(high, lenght):  # получаем значения
    root = Tk()
    root.title('Сапер')
    global buttons
    global mines
    global flags
    flags = []  # Массив, содержащий в себе места, где стоят флажки
    mines = []  # Массив, содержащий в себе места, где лежат мины
    buttons = [[Pole(root, row, column) for column in range(high)] for row in
               range(lenght)]  # Двумерный массив, в котором лежат поля
    for i in buttons:  # Цикл по строкам
        for j in i:  # Цикл по элементам строки
            j.button.grid(column=i.index(j), row=buttons.index(i), ipadx=7,
                          ipady=1)  # Размещаем все в одной сетке при помощи grid
            j.button.bind('<Button-1>', j.view)  # Биндим открывание клетки
            j.button.bind('<Button-3>', j.setFlag)  # Установка флажка
            j.setAround()  # Функция заполнения массива self.around
    buttons[0][0].button.bind('<Control-Button-1>', cheat)  # создаем комбинацию клавиш для быстрого решения
    root.resizable(False, False)  # запрещаем изменения размера
    root.mainloop()


def easySetting():
    global bombs, high, lenght
    bombs = 21
    high = 9
    lenght = 9
    game(high, lenght)


def medSetting():
    global bombs, high, lenght
    bombs = 55
    high = 16
    lenght = 16
    game(high, lenght)


def hardSetting():
    global bombs, high, lenght
    bombs = 103
    high = 30
    lenght = 16
    game(high, lenght)


def bombcounter():
    global bombs
    global lenght
    global high
    if mineText.get('1.0', END) == '\n':  # Проверяем наличие текста
        bombs = 10  # Если текста нет, то по стандарту кол-во бомб - 10
    else:
        bombs = int(mineText.get('1.0', END))  # Если текст есть, то это и будет кол-во бомб
    # if highText.get('1.0', END) == '\n':
    #     high = 9
    # else:
    #    high = int(highText.get('1.0', END))
    high = int(highScale.get())
    if lenghtText.get('1.0', END) == '\n':
        lenght = 9
    else:
        lenght = int(lenghtText.get('1.0', END))
    game(high, lenght)  # Начинаем игру, передавая кол-во полей


outputPath = 'output.txt'
outputPath2 = 'output2.txt'
prolog = Prolog()
prolog.consult("minesweeper.pl")  # Инициализация пролог-программы
settings = Tk()  # Создаем окно
settings.title('Настройки')  # Пишем название окна
settings.geometry('400x250')  # Задаем размер
easyBut = Button(settings, text='Лёгкий 9х9', command=easySetting)
medBut = Button(settings, text='Средний 16х16', command=medSetting)
hardBut = Button(settings, text='Эксперт 16х30', command=hardSetting)
mineText = Text(settings, width=5, height=1)  # Создаем поля для ввода текста и пояснения
mineLabe = Label(settings, height=1, text='Бомбы:')
highScale = Scale(settings, from_=5, to=100, orient=HORIZONTAL)
#highText = Text(settings, width=5, height=1)
highLabe = Label(settings, height=1, text='Ширина:')
lenghtText = Text(settings, width=5, height=1)
lenghtLabe = Label(settings, height=1, text='Высота:')
labe = Label(settings, height=1, text='Пользовательские настройки:')
mineBut = Button(settings, text='Начать', command=bombcounter)  # Создаем кнопку
easyBut.pack(fill=X)
medBut.pack(fill=X)
hardBut.pack(fill=X)
labe.pack()
mineLabe.place(x=5, y=120)
mineText.place(x=70, y=120)
highLabe.place(x=5, y=160)
#highText.place(x=70, y=140)
highScale.place(x=70, y=140)
lenghtLabe.place(x=5, y=180)
lenghtText.place(x=70, y=180)
mineBut.place(x=5, y=210)
settings.mainloop()
