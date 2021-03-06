// При подключении библиотеки необходиомо указать путь к каталогу TFile с библиотекой TFile.
// Путь указывается относительно расположения данного файла.
#Использовать "..\TFile"

//*****************************************************************
Процедура ПолныйТестВсехПроцедур(ФайловыеОперации, Знач РабочийКаталог="")

	// Флаг наличия ошибок
	БылиОшибки = Ложь;
	
	// Создадим необходимые файлы
	Если РабочийКаталог = "" Тогда
		РабочийКаталог = ".\";
	КонецЕсли;
	РабочийКаталог = ОбъединитьПути(РабочийКаталог,"Test_TFile");
	СоздатьКаталог(РабочийКаталог);
	СоздатьКаталог(РабочийКаталог + "\TestDir");
	// Создадим тектовый файл
	ДатаСозданияФайла = ТекущаяДата();
	ИмяФайла = РабочийКаталог + "\TestDir\" + "TestFile.txt";
	Документ = Новый ТекстовыйДокумент;
	Документ.Записать(ИмяФайла);
	Приостановить(1000);
	ЗаписьТекста = Новый ЗаписьТекста;
	ЗаписьТекста.Открыть(ИмяФайла,,,Истина);
	ЗаписьТекста.ЗаписатьСтроку("Тестовая строка");
	ЗаписьТекста.Закрыть();	
	
	// Выведем информацию о дисках компьютера
	ТаблицаДанных = ФайловыеОперации.ИнформацияОДисках("CD",Истина);
	Если ТаблицаДанных <> Неопределено Тогда
		Для Каждого СтрокаДанных ИЗ ТаблицаДанных Цикл
			Сообщить("--- Информация о дисках ---");
			Для Каждого Колонка ИЗ ТаблицаДанных.Колонки Цикл
				Сообщить(Колонка.Имя + ": " + СтрокаДанных[Колонка.Имя]);
			КонецЦикла;
			Сообщить("");
		КонецЦикла
	Иначе
		Сообщить("ИнформацияОДисках: " + ФайловыеОперации.ТекстОшибки);
		БылиОшибки = Истина;
	КонецЕсли;
	
	// Заархивируем файл
	ИмяАрхива = "";
	Если ФайловыеОперации.ДобавитьВАрхив(ИмяФайла,ИмяАрхива) Тогда
		Сообщить("ДобавитьВАрхив: УСПЕШНО в " + ИмяАрхива);
	Иначе
		Сообщить("ДобавитьВАрхив: " + ФайловыеОперации.ТекстОшибки);
		БылиОшибки = Истина;
	КонецЕсли;

	// Скоприуем файл
	ИмяСкопированногоФайла = ФайловыеОперации.СкопироватьФайл(ИмяФайла);
	Если ИмяСкопированногоФайла <> Неопределено Тогда
		Сообщить("СкопироватьФайл: УСПЕШНО в " + ИмяСкопированногоФайла);
	Иначе
		Сообщить("СкопироватьФайл: " + ФайловыеОперации.ТекстОшибки);
		БылиОшибки = Истина;
	КонецЕсли;
	
	// Скопируем несколько файлов
	МассивФайлов = Новый Массив;
	МассивФайлов.Добавить(ИмяСкопированногоФайла);
	МассивФайлов.Добавить(ИмяАрхива);
	Если ФайловыеОперации.СкопироватьФайлы(МассивФайлов,РабочийКаталог) Тогда
		Сообщить("СкопироватьФайлы: УСПЕШНО в " + ФайловыеОперации.ИнформацияОФайле(РабочийКаталог).Путь);
	Иначе
		Сообщить("СкопироватьФайлы: " + ФайловыеОперации.ТекстОшибки);
		БылиОшибки = Истина;
	КонецЕсли;

	// Информация о файле
	СтруктураПараметров = ФайловыеОперации.ИнформацияОФайле(ИмяСкопированногоФайла);
	Если СтруктураПараметров <> Неопределено Тогда
		Сообщить("Информация о файле: ");
		Для Каждого Параметр ИЗ СтруктураПараметров Цикл
			Сообщить("	" + Параметр.Ключ + ": " + Параметр.Значение);
		КонецЦикла;
	Иначе
		Сообщить("ИнформацияОФайле: " + ФайловыеОперации.ТекстОшибки);
		БылиОшибки = Истина;
	КонецЕсли;	
	УдалитьФайлы(ИмяСкопированногоФайла);
	
	// Информация обо всех файлах в каталоге
	ТаблицаДанных = ФайловыеОперации.ИнформацияОФайлах(РабочийКаталог,Истина);
	Если ТаблицаДанных <> Неопределено Тогда
		Для Каждого СтрокаДанных ИЗ ТаблицаДанных Цикл
			Сообщить("Информация о файле: ");
			Для Каждого Колонка ИЗ ТаблицаДанных.Колонки Цикл
				Сообщить("	" + Колонка.Имя + ": " + СтрокаДанных[Колонка.Имя]);
			КонецЦикла;
		КонецЦикла;
	Иначе
		Сообщить("ИнформацияОФайлах: " + ФайловыеОперации.ТекстОшибки);
		БылиОшибки = Истина;
	КонецЕсли;
	
	// Удалим файлы, старше указанной даты
	ФайловыеОперации.УдалитьФайлыСозданныеРаннееДаты(РабочийКаталог,ДатаСозданияФайла,"*.txt",Истина);
	Сообщить("УдалитьФайлыСозданныеРаннееДаты: УСПЕШНО");
	
	// Удалим файлы, которые были изменены раньше указанной даты
	ФайловыеОперации.УдалитьФайлыИзмененныеРаннееДаты(РабочийКаталог,ТекущаяДата(),,Истина);
	Сообщить("УдалитьФайлыИзмененныеРаннееДаты: УСПЕШНО");
	
	// Удалим пустые каталоги, включая текущий
	Если ФайловыеОперации.УдалитьПустыеКаталоги(РабочийКаталог,Истина) Тогда
		Сообщить("УдалитьПустыеКаталоги: УСПЕШНО");
	Иначе
		Сообщить("УдалитьПустыеКаталоги: " + ФайловыеОперации.ТекстОшибки);
		БылиОшибки = Истина;
	КонецЕсли;	
	
	// Отчет о работче процедуры
	Сообщить("");
	Сообщить("-----------------------------------------------");
	Сообщить("Результат работы тестирования модуля: " + ?(БылиОшибки,"БЫЛИ ОШИБКИ","УСПЕШНО"));
	Сообщить("-----------------------------------------------");
	Сообщить("");

КонецПроцедуры

//*****************************************************************

// Создадим объект
ФайловыеОперации = Новый ТУправлениеФайловымиОперациями();
	
// Запустим тест всех процедур
ПолныйТестВсехПроцедур(ФайловыеОперации)

	
	
	