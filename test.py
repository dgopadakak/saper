from pyswip import Prolog

lines = 10  #
columns = 9  # Входные данные
mines = 12  #
minesCoord = [2, 3, 10, 9, 10, 3, 5, 8, 3, 9, 1, 6, 2, 2, 8, 9, 9, 1, 5, 6, 8, 1, 8, 8]  # Рандомные координаты мин
outputPath = '/home/pavel/PycharmProjects/Saper/output.txt'
outputPath2 = '/home/pavel/PycharmProjects/Saper/output2.txt'
prolog = Prolog()
global queryString
prolog.consult("minesweeper.pl")  # Инициализация пролог-программы

queryString = f"tell('{outputPath2}')."  # Открытие output2.txt на запись
for soln in prolog.query(queryString):
    print(soln)

queryString = f"info({lines}, {columns}, {mines}), minesweeper({lines}, {columns}), mines({mines}), print_store, told."  # Запрос на рандомизацию мин

for soln in prolog.query(queryString):
    print(soln)

queryString = f"tell('{outputPath}'), info({lines}, {columns}, {mines}), minesweeper({lines}, {columns})"

for i in range(0, len(minesCoord)):
    if i % 2 == 0:
        queryString += f", mine({minesCoord[i]}, "
    else:
        queryString += f"{minesCoord[i]})"

queryString += f",check({1},{1}), print_field, told."   # Запрос на проверку клетки (x, y) и отрисовкку поля в output.txt
for soln in prolog.query(queryString):
    print(soln)
queryString = queryString.replace(" print_field,", "")  # Удаление  print_field, для того, чтобы в output.txt была только одна карта

def on_cell_click_listener():
    x = 2  #
    y = 4  # Здесь должны вычисляються координаты нажатой клетки
    queryString = queryString.replace(", told.", "")        #
    queryString += f",check({x},{y}), print_field, told."   # Запрос на проверку клетки (x, y) и отрисовкку поля в output.txt
    for soln in prolog.query(queryString):
        print(soln)
    queryString = queryString.replace(" print_field,", "")  # Удаление  print_field, для того, чтобы в output.txt была только одна карта
