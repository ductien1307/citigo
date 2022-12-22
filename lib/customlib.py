import readexcel

def openExcelPython(excelName):
    return readexcel.openExcelPython(excelName)

def getAllRowValuePython(excelOpened, rowNum):
    return readexcel.getAllRowValuePython(excelOpened, rowNum)

def getCellValuePython(excelOpened, rowNum, columnNum):
    return readexcel.getCellValuePython(excelOpened, rowNum, columnNum)

def getAllColumnValuePython(excelOpened, columnNum):
    return readexcel.getAllColumnValuePython(excelOpened, columnNum)

def getAllColumnValueFromSpecialRowPython(excelOpened, columnNum, rowNum):
    return readexcel.getAllColumnValueFromSpecialRowPython(excelOpened, columnNum, rowNum)
