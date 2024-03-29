
#Использовать asserts


Функция ПроверитьРасположение(ИмяПриложения)
    
    ПроцесПроверки = СоздатьПроцесс("where " + ИмяПриложения,,Истина,Ложь);
    
    ПроцесПроверки.Запустить();
    ПроцесПроверки.ОжидатьЗавершения();
    
    РезультатПроверки = ПроцесПроверки.ПотокВывода.Прочитать();
    
    Возврат СтрРазделить(РезультатПроверки, Символы.ПС, Ложь);
    
КонецФункции // ПроверитьРасположение(ИмяПриложения)

Функция ВерсияДокерМашины()
    
    процесДокерМашины = СоздатьПроцесс("docker-machine --version",,Истина,Ложь);

	процесДокерМашины.Запустить();
	процесДокерМашины.ОжидатьЗавершения();

	СтрокаВывода = "";
	СтрокаВывода = процесДокерМашины.ПотокВывода.Прочитать();

	Сообщить("Версия докер машины " + СтрокаВывода);

	Возврат СтрокаВывода;

КонецФункции

Функция ДокерМашинаБезКонфликтов()
    
    МассивРаположений = ПроверитьРасположение("docker-machine");
    
    Если МассивРаположений.Количество() = 1 Тогда
        Сообщить("Адрес расположения docker-machine " + МассивРаположений[0]);
        Возврат Истина;
    Иначе
        Сообщить("Конфликт расположений docker-machine");
        Для Каждого _расположение из МассивРаположений Цикл
            Сообщить("" +_расположение);
            
            Если СтрЧислоВхождений(_расположение,"chocolatey") > 0 Тогда
                Сообщить("Вы автоматически установили docker-machine через choco, и установили docker-machine через GUI инсталятор
                |Лучше тогда удалить choco версию через команду 'choco uninstall docker-machine'");
            КонецЕсли;
            
        КонецЦикла;
        
        Возврат Ложь;
    КонецЕсли;
    
    
КонецФункции // ДокерМашинаБезКонфликтов()

Функция ВерсияИнсталятора()
    
    процесИнсталятора = СоздатьПроцесс("choco",,Истина,Ложь);

	процесИнсталятора.Запустить();
	процесИнсталятора.ОжидатьЗавершения();

	СтрокаВывода = "";
	СтрокаВывода = процесИнсталятора.ПотокВывода.Прочитать();

    _массивВывода = СтрРазделить(СтрокаВывода," ");
    
    Если _массивВывода.Количество() > 1 Тогда
        
        _версияСтрокой = СтрЗаменить(_массивВывода[1],"v","");
        Сообщить("Версия инсталятора choco " + _версияСтрокой);
       
        Возврат _версияСтрокой;
        
    Иначе
        ВызватьИсключение "Инстаялтор choco не доступен 
        |" + СтрокаВывода
    КонецЕсли;

	Возврат Число(СтрокаВывода);
    
КонецФункции // ИмяФункции()


Ожидаем.Что(ВерсияИнсталятора()).Содержит("0.9.9");

Ожидаем.Что(ВерсияДокерМашины()).Содержит("0.6");
Ожидаем.Что(ДокерМашинаБезКонфликтов()).ЭтоИстина();
