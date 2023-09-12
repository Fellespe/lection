script_author('Fellespe', 'TravkaCode')
script_name('Lection')

--	ЗАВИСИМОСТИ
require('lib.moonloader')
local dlstatus = require('moonloader').download_status
local sampev = require('lib.samp.events')
local encoding = require('encoding')
local inicfg = require('inicfg')

--	ПЕРЕМЕННЫЕ
local lt
local ltt
local waitIni
local nick
local org
local directIni = "moonloader\\lection.ini"
local mainIni = inicfg.load(nil, directIni)
encoding.default = 'CP1251'
local uft = encoding.UFT8
local tag = "{96c8a2}[Лекцион]: "

local ini = inicfg.load(nil, "lectionconf.ini")

local update_state = false
local updateIni

local script_vers_text = "v1.4"
local script_vers = 5
local script_path = thisScript().path
local script_url = "https://github.com/Fellespe/lection/raw/main/lection.luac"
local update_path = getWorkingDirectory() .. "/update.ini"
local update_url = "https://raw.githubusercontent.com/Fellespe/lection/main/update.ini"
local update_ini_url = "https://raw.githubusercontent.com/Fellespe/lection/main/lection.ini"
local update_ini_path = getWorkingDirectory() .. "/lection.ini"

function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end
		--Один раз после запуска игры
		wait(500)

		downloadUrlToFile(update_ini_url, update_ini_path, function() end)

		ltt = 4500

		if doesFileExist("moonloader/config/lectionconf.ini") == false then
			ini = inicfg.load(--[[Начали подгрузку]]{ --[[Отклыли таблицу]]
			    config = { --[[Открыли подвкладку]]
			        waitlt=3000 --[[Добавили в подвкладку переменную]]
			    }--[[Закрыли подвкладку]]
			}--[[Закрыли таблицу]]) --[[Завершили подгрузку]]
			inicfg.save(ini, "lectionconf.ini")
		end


		-- КОМАНДЫ
		sampRegisterChatCommand('lections', cmd_lections)
		sampRegisterChatCommand('linfo', cmd_linfo)
		sampRegisterChatCommand('ltimer', cmd_ltimer)

		lt = tonumber(ini.config.waitlt)

		wait(3000)
		sampAddChatMessage(tag .. "{ffffff}Скрипт успешно загружен!", -1)
		sampAddChatMessage(tag .. "{ffffff}Текущая версия скрипта - " .. script_vers_text, -1)
		sampAddChatMessage(tag .. "{ffffff}Использование - /lections, /linfo, /ltimer", -1)

 		downloadUrlToFile(update_url, update_path, function(id, status)
			if status == dlstatus.STATUS_ENDDOWNLOADDATA then
				updateIni = inicfg.load(nil, update_path)
				if tonumber(updateIni.info.vers) > script_vers then
					sampAddChatMessage(tag .. "{ffffff}Найдено обновление! Версия - " .. updateIni.info.vers_text, -1)
					update_state = true
				end
				os.remove(update_path)
			end
		end)

	while true do
		wait(0)
		--Вечный цикл после запуска
 		if update_state then
			downloadUrlToFile(update_ini_url, update_ini_path, function() end)
			downloadUrlToFile(script_url, script_path, function(id, status)
				if status == dlstatus.STATUS_ENDDOWNLOADDATA then
					wait(1000)
					sampAddChatMessage(tag .. "{ffffff}Скрипт успешно обновлен!", -1)
					thisScript():reload()
				end
			end)
			break
		end

		local armyres, armyb, armyl, armyi = sampHasDialogRespond(5001)
		local fsbres, fsbb, fsbl, fsbi = sampHasDialogRespond(5002)
		local smires, smib, smil, smii = sampHasDialogRespond(5003)
		--local govres, govb, govl, govi = sampHasDialogRespond(5004)
		local medres, medb, medl, medi = sampHasDialogRespond(5005)
		local licres, licb, licl, lici = sampHasDialogRespond(5006)
		--local fsinres, fsinb, fsinl, fsini = sampHasDialogRespond(5007)
		local policeres, policeb, policel, policei = sampHasDialogRespond(5008)

		local waitsres, waitsb, waitsl, waitsi = sampHasDialogRespond(5020)

		if waitsres == true then
			if waitsb == 1 then
				if not tonumber(waitsi) then
					sampAddChatMessage(tag .. "{ffffff}Принимаются только числа!", -1)
				elseif tonumber(waitsi) <= 500 then
					sampAddChatMessage(tag .. "{ffffff}Слишком маленькая задержка!", -1)
				else
					waitIni = tonumber(waitsi)
					ltimer()
				end
			end
		end

		if armyres == true then
			if armyb == 1 and armyl == 0 then
				armyRuleStroy()
			elseif armyb == 1 and armyl == 1 then
				armyNewB()
			elseif armyb == 1 and armyl == 2 then
				armySamovolka()
			elseif armyb == 1 and armyl == 3 then
				armySub()
			elseif armyb == 1 and armyl == 4 then
				armyKPP()
			elseif armyb == 1 and armyl == 5 then
				armyStroy()
			elseif armyb == 1 and armyl == 6 then
				armyCHS()
			end
		end

		if fsbres == true then
			if fsbb == 1 and fsbl == 0 then
				mvdRadio()
			elseif fsbb == 1 and fsbl == 1 then
				fsbEtk()
			elseif fsbb == 1 and fsbl == 2 then
				mvdSub()
			elseif fsbb == 1 and fsbl == 3 then
				fsbUsb()
			elseif fsbb == 1 and fsbl == 4 then
				fsbCsn()
			elseif fsbb == 1 and fsbl == 5 then
				mvdTren()
			elseif fsbb == 1 and fsbl == 6 then
				mvdTab()
			elseif fsbb == 1 and fsbl == 7 then
				mvdArest()
			end
		end

			if smires == true then
				if smib == 1 and smil == 0 then
					smiRadio()
				elseif smib == 1 and smil == 1 then
					smiCar()
				elseif smib == 1 and smil == 2 then
					smiSub()
				elseif smib == 1 and smil == 3 then
					smiUstav()
				elseif smib == 1 and smil == 4 then
					smiDress()
				end
			end

			if medres == true then
				if medb == 1 and medl == 0 then
					medNarKrov()
				elseif medb == 1 and medl == 1 then
					medOPerel()
				elseif medb == 1 and medl == 2 then
					medZPerel()
				elseif medb == 1 and medl == 3 then
					medUdar()
				elseif medb == 1 and medl == 4 then
					medOzhog()
				elseif medb == 1 and medl == 5 then
					medAntiSep()
				elseif medb == 1 and medl == 6 then
					medAntibio()
				elseif medb == 1 and medl == 7 then
					medOtmor()
				elseif medb == 1 and medl == 8 then
					medPeredoza()
				end
			end

			if policeres == true then
				if policeb == 1 and policel == 0 then
					mvdRadio()
				elseif policeb == 1 and policel == 1 then
					mvdArest()
				elseif policeb == 1 and policel == 2 then
					mvdSub()
				elseif policeb == 1 and policel == 3 then
					policePDD()
				elseif policeb == 1 and policel == 4 then
					policeForRyad()
				elseif policeb == 1 and policel == 5 then
					policeShtr()
				elseif policeb == 1 and policel == 6 then
					mvdTren()
				elseif policeb == 1 and policel == 7 then
					mvdTab()
				end
			end

			if licres == true then
				if licb == 1 and licl == 0 then
					licDress()
				elseif licb == 1 and licl == 1 then
					licCar()
				elseif licb == 1 and licl == 2 then
					licVPO()
				end
			end

	end
end

function ltimer()
	ini.config.waitlt = waitIni
	if inicfg.save(ini, "lectionconf.ini") then
		sampAddChatMessage(tag .. "{ffffff}Задержка успешно сохранена!", -1)
		lt = tonumber(ini.config.waitlt)
	else
		sampAddChatMessage(tag .. "{ffffff}В время сохранения произошла ошибка!", -1)
	end
end

function cmd_ltimer()
	lua_thread.create(function()
		sampShowDialog(5020, "{ffffff}Настройка задержки", "{ffffff}\nВ поле ниже введите желаемое время задержки между сообщениями в лекциях.\nЗадержка указывается в миллисекундах!\n1сек = 1000мс\n\nНа данный момент задержка: " .. ini.config.waitlt .. "мс.\n ", "Сохранить", "Отмена", 1)
	end)
end

function cmd_linfo()
	sampShowDialog(5010, "{ffffff}Информация о скрипте {35df6f}Лекцион",
	"{ffffff}\nРазработка скрипта:\nIvan_Hramov ({4C75A3}VK: {ffffff}@vanjakiller) \n{ffffff}Alex_Fominov ({4C75A3}VK: {ffffff}@travkacode.developer)\nСообщить о {35df6f}багах/недоработках{ffffff} можете напрямую разработчикам в {4C75A3}VK{ffffff}!\n\nСпасибо, что используете {35df6f}Лекцион!\n\n{f85959}Специально {ffffff}для Rodina Role Play Northern District", "Ок", "", 0)
end

function sampev.onServerMessage(color, text)
	_, id = sampGetPlayerIdByCharHandle(PLAYER_PED) -- ид игрока
  nick = sampGetPlayerNickname(id) -- ник игрока
	lua_thread.create(function()
		if text:find(nick .. " " .. 'переодевается в раб') then
			wait(300)
	    checktab()
		end

		if text:find(nick .. " " .. 'переодевается в гражд') then
			wait(300)
	    checktab()
		end
	end)
end

function checktab()
	lua_thread.create(function()
		org = sampGetPlayerColor(id)
	end)
end

function cmd_lections()
	lua_thread.create(function()
		if org == mainIni.config.army then
			sampShowDialog(5001, "{ffffff}Список лекций для {693f14}Армии", '01 | Правила поведения в строю\n02 | Лекция новобранцам\n03 | Самоволка\n04 | Субординация\n05 | Правило обращения с гражданами на КПП\n06 | Строевая подготовка\n07 | "Как правильно действовать при нападение на ВЧ"', "Выбрать", "Отмена", 2)
		elseif org == mainIni.config.fsb then
			sampShowDialog(5002, "{ffffff}Список лекций для {5900cb}ФСБ", "01 | Рация\n02 | Этикет\n03 | Субординация\n04 | УСБ\n05 | ЦСН\n05 | Правила поведения на тренировке\n06 | Правила использования табельного оружия\n07 | Задержание", "Выбрать", "Отмена", 2)
		elseif org == mainIni.config.smi then
			sampShowDialog(5003, "{ffffff}Список лекций для {ff8a00}СМИ", "01 | Рация\n02 | Использование рабочего транспорта\n03 | Субординация\n04 | Устав\n05 | Дресс-код", "Выбрать", "Отмена", 2)
--		elseif org == mainIni.config.gov then
--			sampShowDialog(5004, "{ffffff}Список лекций для {d6ce11}Правительства", "01 | Рация\n02 | Использование рабочего транспорта\n03 | Субординация\n04 | Устав\n05 | Дресс-код", "Выбрать", "Отмена", 2)
elseif org == mainIni.config.med then
			sampShowDialog(5005, "{ffffff}Список лекций для {ec18d7}МЗ", "01 | Виды наружных кровотечений\n02 | Открытые переломы\n03 | Закрытые переломы\n04 | Солнечный и тепловой удар\n05 | Виды ожогов\n06 | Антисептические средства\n07 | Антибиотики\n08 | Отморожение\n09 | Передозировка", "Выбрать", "Отмена", 2)
		elseif org == mainIni.config.lic then
			sampShowDialog(5006, "{ffffff}Список лекций для {d64518}МРЭО ГИБДД", "01 | Дресс-код\n02 | Использование рабочего транспорта\n03 | ВПО", "Выбрать", "Отмена", 2)
--		elseif org == mainIni.config.fsin then
--			sampShowDialog(5007, "{ffffff}Список лекций для {676e70}ФСИН", "01 | Рация\n02 | Использование рабочего транспорта\n03 | Субординация\n04 | Устав\n05 | Дресс-код", "Выбрать","Отмена", 2)
elseif org == mainIni.config.police then
			sampShowDialog(5008, "{ffffff}Список лекций для {1c00ff}Полиции", "01 | Рация\n02 | Задержание\n03 | Субординация\n04 | ПДД (ГУМВД)\n05 | Лекция для рядовых (ГУМВД)\n06 | Штрафы (ГУМВД)\n07 | Правила поведения на тренировке\n08 | Правила использования табельного оружия", "Выбрать", "Отмена", 2)
		else
			sampShowDialog(4884, "Ошибка определения фракции", "Если вы видите данное окно, значит авторизация в скрипте прошла неудачно.\nВозможно вы не сотрудник гос структур, в таком случае можете просто закрыть это окно.\nЕсли же вы являетесь сотрудником гос структур, убедитесь, что в время надевания формы, на вас не было маски.\nДля повторной авторизации, переоденьтесь в гражданскую форму, после чего обратно в рабочую.\nЕсли всё еще не работает, убедитесь, что в скрипте не вызвана ошибка, через консоль SampFuncs.\nПерезагрузить ЛУА скрипты: Ctrl+R", "Ок", "", 0)
		end
	end)
end

------------------------------------------------------------------------ БЛОК ЛЕКЦИЙ ------------------------------------------------------------------------

-- fSB, POLICE AND MVD
function fsbEtk() -- Этикет
	sampSendChat("Сейчас проведем лекцию по этикету.")
	wait(ltt)
	sampSendChat("У вас всегда должны быть чистые костюмы.")
	wait(lt)
	sampSendChat("Вы всегда должны быть в глаженной рубашке.")
	wait(lt)
	sampSendChat("На вас всегда должны быть одеты очки.")
	wait(lt)
	sampSendChat("У вас всегда должны быть чистые туфли.")
	wait(lt)
	sampSendChat("На этом лекция по этикету окончена, всем спасибо за внимание.")
end

function fsbUsb() -- УСБ
	sampSendChat('Здравствуйте, сегодня я Вам прочитаю лекцию по отделу "УСБ".')
	wait(ltt)
	sampSendChat("Основная деятельность УСБ - Управление Собственной Безопасности:")
	wait(lt)
	sampSendChat("Контроль за государственными структурами области,")
	wait(lt)
	sampSendChat("Выявление фактов коррупции в государственных структурах области,")
	wait(lt)
	sampSendChat("Выявление фактов нарушений законов области в силовых структурах,")
	wait(lt)
	sampSendChat("Обучение и контроль работы младшей агентуры ФСБ,")
	wait(lt)
	sampSendChat("Слежки и выдвижения потенциальных кандидатов для вербовки в ФСБ,")
	wait(lt)
	sampSendChat("Проведение проверок на ФП, УК, Устав,")
	wait(lt)
	sampSendChat("Проведение лекций в государственных структурах на различные темы,")
	wait(lt)
	sampSendChat("Проведение тренировок как для агентов ФСБ, так и для других государственных организаций.")
	wait(lt)
	sampSendChat('На этом лекция по отделу "УСБ" завершена, благодарю за внимание.')
end

function fsbCsn() -- ЦСН
	sampSendChat('Здравствуйте, сегодня я Вам расскажу лекцию по отделу "ЦСН".')
	wait(ltt)
	sampSendChat("ЦСН — Является одним из самых засекреченных управлением.")
	wait(lt)
	sampSendChat("Данное управление расследует широкий спектр всех федеральных преступлений, такие как:")
	wait(lt)
	sampSendChat("В обязанности управления ЦСН входит:")
	wait(lt)
	sampSendChat("Осуществление специальных силовых операций")
	wait(lt)
	sampSendChat("Борьба с терроризмом, поиск, обезвреживанию или ликвидации террористов.")
	wait(lt)
	sampSendChat("Освобождению заложников и т. д...")
	wait(lt)
	sampSendChat("Внедрения/сбор информации, аресты,")
	wait(lt)
	sampSendChat("Слежка за государственными структурами, проведение спец.операций,")
	wait(lt)
	sampSendChat("Предотвращение и подавление терактов, и многое другое.")
	wait(lt)
	sampSendChat("Организованная преступность, преступления на расовой почве и многое другое.")
	wait(lt)
	sampSendChat("Ну, а на этом лекция завершена, благодарю за внимание.")
end

function policeShtr() -- Штрафы
	sampSendChat('Здравствуйте, уважаемые коллеги! Сегодня я прочитаю Вам лекцию на тему "Штрафы"!')
	wait(ltt)
	sampSendChat("Если Вы увидели нарушителя, Вы должны сначала подойти к нему и представится!")
	wait(lt)
	sampSendChat("После чего сообщить ему, что он нарушил!")
	wait(lt)
	sampSendChat("Если он не пытается убегать, то достаете талон и начинаете оформлять штраф!")
	wait(lt)
	sampSendChat("После этого передаете ему бланк!")
	wait(lt)
	sampSendChat("/b выписывать только по РП! Через /me всё сделать, а только потом прописывать команду /ticket.")
	wait(lt)
	sampSendChat("После чего пожелать ему удачного дня и отпустить его!")
	wait(lt)
	sampSendChat("На этом лекция окончена! Есть вопросы?!")
end

function policeForRyad() -- Для рядовых
	sampSendChat('Здравия желаю кадеты, с этого момента вы являетесь Сотрудниками "ГУМВД".')
	wait(ltt)
	sampSendChat("Сразу расскажу о правилах в строю: разговаривать, выкрикивать из строя и перебивать запрещено.")
	wait(lt)
	sampSendChat("Спрашивать что-либо тоже запрещается. Все вопросы после строя.")
	wait(lt)
	sampSendChat("Также, в строю запрещено доставать оружие, стрелять, нарушать строевую тишину, говорить по телефону.")
	wait(lt)
	sampSendChat("В ГУМВД как и в армии вы должны соблюдать строгую субординацию.")
	wait(lt)
	sampSendChat("Это подразумевает: не хамить старшим, не пререкаться с ними, не перебивать.")
	wait(lt)
	sampSendChat('В ГУМВД нет слов "Можно, нельзя, да, не знаю, спасибо, сэр."')
	wait(lt)
	sampSendChat('Вы должны чётко и кратко формулировать мысли: "Разрешите, никак нет, так точно, не могу знать, есть."')
	wait(lt)
	sampSendChat("Обращаться к друг другу так: т.Звание")
	wait(lt)
	sampSendChat("Ваша основная задача - контроль дорожного движения.")
	wait(lt)
	sampSendChat("Использование оружия в личных целях строго запрещено!")
	wait(lt)
	sampSendChat("Кто ослушается - будет уволен и занесён в черный список ГУМВД.")
	wait(lt)
	sampSendChat("Использование оружия разрешено только при каких либо ситуациях. Например: ЧС, тренировках,...")
	wait(lt)
	sampSendChat("...при ловле ОП и ООП.")
	wait(lt)
	sampSendChat("Стрельба без причины наказывается по Федеральному Постановлению.")
	wait(lt)
	sampSendChat("Для всех работа с 12:00 до 20:00. Обеденный перерыв с 15:00 до 16:00.")
	wait(lt)
	sampSendChat("В случаи прогула рабочего дня. Вы будете уволены по Федеральному Постановлению 1.7")
	wait(lt)
	sampSendChat("Спать вам разрешено только в комнате отдыха.")
	wait(lt)
	sampSendChat("Ещё ближе ознакомиться с уставом и правилами Вы можете на офФ. портале Республики.")
	wait(lt)
	sampSendChat("Лекция для Рядовых окончена. Спасибо за внимание.")
end

function policePDD() -- ПДД
	sampSendChat("Приветствую вас на лекции о ПДД.")
	wait(ltt)
	sampSendChat("Если кому-то неизвестно, ПДД расшифровывается, как Правила Дорожного Движения.")
	wait(lt)
	sampSendChat("И в данной лекции я расскажу о этих правилах.")
	wait(lt)
	sampSendChat("Сначала поговорим об ограничениях скорости.")
	wait(lt)
	sampSendChat("За пределом города разрешено ехать максимум 120 км/ч")
	wait(lt)
	sampSendChat("В городе разрешена максимальная скорость - 60 км/ч.")
	wait(lt)
	sampSendChat("Остановка и стоянка транспортного средства разрешена на обочине или же в отведенных для этого местах.")
	wait(lt)
	sampSendChat("Обгон разрешен только с левой стороны.")
	wait(lt)
	sampSendChat("Если вы попали в ДТП, надо позвонить в полицию и вызвать их на место аварии.")
	wait(lt)
	sampSendChat("На этом у меня все, спасибо за внимание, лекция окончена.")
end

function mvdTren() -- Правила поведения на тренировке
	sampSendChat("Здравия желаю, коллеги сейчас я проведу вам лекцию.")
	wait(lt)
	sampSendChat('Лекция на тему "Правила поведения на тренировке".')
	wait(ltt)
	sampSendChat("С самого начала я хочу сказать, что такое тренировка.")
	wait(lt)
	sampSendChat("Тренировка — это осмысленная физическая деятельность, направленная на развитие силы,")
	wait(lt)
	sampSendChat("выносливости, ловкости, техничности, скорости и других физических и психологических навыков.")
	wait(lt)
	sampSendChat("Правила поведение на тренировке:")
	wait(lt)
	sampSendChat("1. Слушаться старших по званию.")
	wait(lt)
	sampSendChat("2. Доставать оружие только по приказу.")
	wait(lt)
	sampSendChat("3. Не покидать строй, только по приказу.")
	wait(lt)
	sampSendChat("4. В строю молчать, слушать что говорят ваши коллеги.")
	wait(lt)
	sampSendChat("5. Слушаться только ст.состав.")
	wait(lt)
	sampSendChat("6. Тренеровку может начать со звание Лейтенант и выше.")
	wait(lt)
	sampSendChat("7. Вы должны четко и внимательно слушать ст.состав.")
	wait(lt)
	sampSendChat("8. Если вы будете спать в строю вам будут давать выговор.")
	wait(lt)
	sampSendChat("9. Если вы устали, вы можете подойти к тому кто организовал тренировку и попросить отдохнуть.")
	wait(lt)
	sampSendChat("10. С разрешение Майора и выше, вы можете не являться на тренировку.")
	wait(lt)
	sampSendChat("А на этом наша лекция подошла к концу.")
	wait(lt)
	sampSendChat("Спасибо за внимание.")
end

function mvdTab() -- Правила использования табельного оружия
	sampSendChat("Приветствую вас на лекции о табельном оружии.")
	wait(ltt)
	sampSendChat("Сегодня я расскажу о правилах использования табельного оружия.")
	wait(lt)
	sampSendChat("Начну с того, что табельное оружие - это важная часть экипировки сотрудника полиции.")
	wait(lt)
	sampSendChat("Надо запомнить, что с табельным оружием надо обращаться с огромной осторожностью.")
	wait(lt)
	sampSendChat("Использовать его, если вам, вашему коллеги или же гражданину штата угрожает опасность.")
	wait(lt)
	sampSendChat("Надо стараться не использовать оружие в людных местах, если даже есть крайняя необходимость,...")
	wait(lt)
	sampSendChat("...ведь из-за это могут пострадать невинные люди.")
	wait(lt)
	sampSendChat("Важно то, что правильное использование оружия может спасти кому-то жизнь.")
	wait(lt)
	sampSendChat("Поэтому табельное оружие всегда должно быть исправно.")
	wait(lt)
	sampSendChat("Если оружие повредилось, надо заменить его или же починить его.")
	wait(lt)
	sampSendChat("Надеюсь, вы все усвоили, спасибо за прослушивание лекции.")
end

function mvdRadio() -- Рация
	sampSendChat('Здравствуйте, уважаемые коллеги! Сегодня я прочитаю Вам лекцию на тему "Рация"!')
	wait(ltt)
	sampSendChat("Рация — это источник связи с коллегами для передачи важной информации!")
	wait(lt)
	sampSendChat("В рацию делают доклады с постов, с патрулей и прочая информация по работе!")
	wait(lt)
	sampSendChat("В рацию запрещены оскорбления, мат, угрозы, купля-продажа.")
	wait(lt)
	sampSendChat("За нарушение данных правил Вы понесете наказание!")
	wait(lt)
	sampSendChat("На этом лекция окончена! Есть вопросы?")
end

function mvdArest() -- Задержание
	sampSendChat('Здравствуйте, уважаемые коллеги! Сегодня я прочитаю Вам лекцию на тему "Задержание"!')
	wait(ltt)
	sampSendChat("При получение звание Сержант, вы должны кое-что осознать!")
	wait(lt)
	sampSendChat("Это не только престиж, но и большая ответственность!")
	wait(lt)
	sampSendChat('Сегодня я Вам расскажу о "Правилах задержания преступников под стражу"!')
	wait(lt)
	sampSendChat("Если вы стоите на посту и видите преступника, который подозревается в преступлении!")
	wait(lt)
	sampSendChat("Обязательно у вас при задержании должен быть напарник!")
	wait(lt)
	sampSendChat("А у Вас есть в наличии его фоторобот, Вы должны подойти к нему!")
	wait(lt)
	sampSendChat("Сначала представьтесь и покажите свое удостверение!")
	wait(lt)
	sampSendChat("Если данный человек в розыске, Вы проводите задержание!")
	wait(lt)
	sampSendChat("/b с полной отыгровкой /me")
	wait(lt)
	sampSendChat("Далее отвозите его в Полицию, где вы садите его в КПЗ!")
	wait(lt)
	sampSendChat("На этом лекция окончена! Есть вопросы?!")
end

function mvdSub() -- Субординация
	sampSendChat('Сейчас я проведу лекцию на тему "Субординация".')
	wait(ltt)
	sampSendChat("Субординация — военная дисциплина, система служебных отношений, связанных с подчинением одних")
	wait(lt)
	sampSendChat("Она предусматривает уважительные отношения между руководителем и подчинённым")
	wait(lt)
	sampSendChat("А также порядка доклада результатов выполнения распоряжения руководителей.")
	wait(lt)
	sampSendChat("В гос.организациях правила субординации устанавливают:")
	wait(lt)
	sampSendChat("Порядок соблюдения определённых традиций.")
	wait(lt)
	sampSendChat('Так же для обращения к старшему по званию, нужно сказать "т.Звание".')
	wait(lt)
	sampSendChat("Примеры обращения и замены неправильных слов:")
	wait(lt)
	sampSendChat('"Здравствуйте" на "Здравия желаю".')
	wait(lt)
	sampSendChat('"Да" на "Так точно".')
	wait(lt)
	sampSendChat('"Нет" на "Никак нет".')
	wait(lt)
	sampSendChat('"Можно?" на "Разрешите?".')
	wait(lt)
	sampSendChat('"Не знаю" - "Не могу знать".')
	wait(lt)
	sampSendChat('"Ладно, хорошо" на "Есть".')
	wait(lt)
	sampSendChat("Несоблюдение субординации - это нарушение Федерального Постановление 1.25,...")
	wait(lt)
	sampSendChat("...за которое вы можете получить наказание.")
	wait(lt)
	sampSendChat("На этом лекция завершена, благодарю за внимание.")
end

-- MED
function medNarKrov() -- Виды наружных кровотечений
	sampSendChat('Здравствуйте уважаемые сотрудники, сегодня расскажу вам лекцию на тему "Виды наружных кровотечений".')
	wait(ltt)
	sampSendChat("Наружным кровотечением в травматологии называется истечение крови во внешнюю среду.")
	wait(lt)
	sampSendChat("Самые опасные кровотечения – артериальные. При повреждении крупных артерий человек...")
	wait(lt)
	sampSendChat("...может истечь кровью всего за несколько минут.")
	wait(lt)
	sampSendChat("Кровь ярко-красная, вытекает пульсирующей струей, при этом пульсирование...")
	wait(lt)
	sampSendChat("...соответствует ритму сердечных сокращений.")
	wait(lt)
	sampSendChat("Необходимо наложение жгута и немедленная доставка больного...")
	wait(lt)
	sampSendChat("...в специализированное медицинское учреждение.")
	wait(lt)
	sampSendChat("Жгут при артериальных кровотечениях накладывается выше места повреждения.")
	wait(lt)
	sampSendChat("Венозное. Кровь темная, с вишневым оттенком, струится из раны.")
	wait(lt)
	sampSendChat("Кровь при повреждении вены вытекает медленнее, поэтому сгустки образуются, однако...")
	wait(lt)
	sampSendChat("...во многих случаях смываются током крови, поэтому самопроизвольная остановка...")
	wait(lt)
	sampSendChat("...наружного кровотечения может происходить со значительной задержкой.")
	wait(lt)
	sampSendChat("Пациента с таким кровотечением также надо немедленно доставить в мед. учреждение.")
	wait(lt)
	sampSendChat("Капиллярное. Кровь насыщенного красного цвета, похожа на артериальную, однако кровотечение...")
	wait(lt)
	sampSendChat("...в данном случае поверхностное.")
	wait(lt)
	sampSendChat("При отсутствии патологии со стороны системы свертывания такое наружное кровотечение...")
	wait(lt)
	sampSendChat("...останавливается самостоятельно.")
	wait(lt)
	sampSendChat("Благодарю за прослушивание моей лекции, на этом все.")
end

function medOPerel() -- Открытые переломы
	sampSendChat('Здравствуйте уважаемые сотрудники, хотел бы вам рассказать лекцию на тему "Открытые переломы".')
	wait(ltt)
	sampSendChat("Перелом открытого типа представляет собой нарушение целостности костных структур...")
	wait(lt)
	sampSendChat("...сопровождающееся повреждением кожи, реже — слизистой оболочки.")
	wait(lt)
	sampSendChat("Для классификации открытого перелома применяются буквенные и цифровые обозначения.")
	wait(lt)
	sampSendChat("Выделяют следующие степени травмы: I — рана до 1, 5 см; II — повреждение в пределах 2-9 см;")
	wait(lt)
	sampSendChat("III — раневая поверхность больше 10 см; IV — раздавливание и...")
	wait(lt)
	sampSendChat("...размозжение мышц и кожи, повреждение артерий.")
	wait(lt)
	sampSendChat("При открытых травмах часто требуется оперативное вмешательство.")
	wait(lt)
	sampSendChat("Оно заключается во вправлении костей, фиксировании отломков и ушивании раны.")
	wait(lt)
	sampSendChat("Обнаружив человека с признаками перелома, нужно вызвать на место бригаду скорой помощи,..")
	wait(lt)
	sampSendChat("...попутно помогая больному с минимальными потерями дождаться специалистов. Следует:")
	wait(lt)
	sampSendChat("остановить кровотечение; закрыть рану; дать обезболивающее.")
	wait(lt)
	sampSendChat("Благодарю за прослушивание моей лекции, на этом все.")
end

function medZPerel() -- Закрытые переломы
	sampSendChat('Здравствуйте уважаемые сотрудники, хотел бы вам рассказать лекцию на тему "Закрытые переломы". ')
	wait(ltt)
	sampSendChat("Закрытый перелом — нарушение целостности кости без повреждения кожных покровов...")
	wait(lt)
	sampSendChat("...или слизистых оболочек.")
	wait(lt)
	sampSendChat("Каждому закрытому перелому сопутствует появление острой боли.")
	wait(lt)
	sampSendChat("С момента травмы появляется и быстро нарастает отёк в зоне перелома.")
	wait(lt)
	sampSendChat("Подкожная гематома — в начальных этапах соответствует локализации отёка.")
	wait(lt)
	sampSendChat("Нарушение функции — ещё один важный симптом закрытого перелома.")
	wait(lt)
	sampSendChat("Отсутствие возможности опоры, активных движений в конечностях говорит о функциональном ограничении.")
	wait(lt)
	sampSendChat("Деформация конечности, возникшая после травмы, может быть вызвана...")
	wait(lt)
	sampSendChat("...переломом и отчётливо визуально определяться.")
	wait(lt)
	sampSendChat('Патологическая подвижность при "свежем" закрытом переломе приносит интенсивную боль.')
	wait(lt)
	sampSendChat("В лечебном объёме первой помощи при закрытом переломе необходимы:")
	wait(lt)
	sampSendChat("адекватное обезболивание; фиксация (шинирование) повреждённого сегмента;")
	wait(lt)
	sampSendChat("скорая транспортировка в амбулаторное или стационарное учреждение...")
	wait(lt)
	sampSendChat("...для оказания дальнейших этапов помощи.")
	wait(lt)
	sampSendChat("Лечение переломов может быть консервативным (без операции) и оперативным.")
	wait(lt)
	sampSendChat("Консервативное лечение возможно при закрытых переломах без смещения отломков...")
	wait(lt)
	sampSendChat("...либо при их минимальном смещении.")
	wait(lt)
	sampSendChat("Спасибо за прослушивание, на этом моя лекция завершена.")
end

function medUdar() -- Солнечный и тепловой удар
	sampSendChat('Здравствуйте уважаемые сотрудники, сегодня расскажу лекцию на тему "Солнечный и тепловой удар".')
	wait(ltt)
	sampSendChat("Солнечный удар – состояние, которое развивается в результате длительного воздействия...")
	wait(lt)
	sampSendChat("...солнечных лучей на голову и верхнюю часть шеи в жаркую погоду.")
	wait(lt)
	sampSendChat("Тепловой удар – результат общего перегревания организма,..")
	wait(lt)
	sampSendChat("...в том числе под воздействием солнечных лучей.")
	wait(lt)
	sampSendChat("При перегревании организм защищается от высокой температуры с помощью повышенного потоотделения.")
	wait(lt)
	sampSendChat("С другой стороны, при этом с потом происходят потери солей и жидкости...")
	wait(lt)
	sampSendChat("...что приводит к повышению температуры тела и еще большему перегреванию.")
	wait(lt)
	sampSendChat("Симптомы солнечного и теплового удара: Тошнота, рвота, головная боль,..")
	wait(lt)
	sampSendChat("...вялость, зевота, сонливость, покраснение лица,..")
	wait(lt)
	sampSendChat("...шум в ушах, потемнение в глазах, учащение дыхания, сердцебиения, слабость, головокружение.")
	wait(lt)
	sampSendChat("При солнечном ударе могут быть ожоги кожи.")
	wait(lt)
	sampSendChat("Первая помощь при солнечном и тепловом ударе:")
	wait(lt)
	sampSendChat("Укрыть пострадавшего от солнечных лучей, вывести его из душного, жаркого помещения на свежий воздух.")
	wait(lt)
	sampSendChat("Придать пострадавшему полусидячее положение.")
	wait(lt)
	sampSendChat("Расстегнуть стесняющую одежду пострадавшего, снять синтетическую одежду.")
	wait(lt)
	sampSendChat("Дать понюхать ватный тампон, смоченный нашатырным спиртом.")
	wait(lt)
	sampSendChat("Дать пострадавшему обильное питье комнатной температуры – сок, воду,..")
	wait(lt)
	sampSendChat("компот (давать пить ледяные жидкости нельзя.)")
	wait(lt)
	sampSendChat("Спасибо за прослушивание, на этом моя лекция завершена.")
end

function medOzhog() -- Виды ожогов
	sampSendChat('Здравствуйте уважаемые сотрудники, хотел бы вам рассказать лекцию на тему "Разновидности ожогов".')
	wait(ltt)
	sampSendChat("Ожоги бывают: термические, химические, электрические, лучевые.")
	wait(lt)
	sampSendChat("Термические ожоги составляют более 90% от всех видов – это ожоги пламенем, горячим паром и тд..")
	wait(lt)
	sampSendChat("Cтепени тяжести:")
	wait(lt)
	sampSendChat("Ожог 1 степени — это поражением самого поверхностного слоя кожи. Развивается выраженное...")
	wait(lt)
	sampSendChat("...покраснение кожи, ее отек, в пораженном месте отмечаются боли, чувство жжения.")
	wait(lt)
	sampSendChat("При ожоге 2 степени верхний слой кожи полностью погибает и отслаивается, при этом...")
	wait(lt)
	sampSendChat("...образуются пузыри, заполненные прозрачной жидкостью.")
	wait(lt)
	sampSendChat("При ожогах 3 степени кожа поражается практически на всю глубину.")
	wait(lt)
	sampSendChat("При этом образуются массивные пузыри с толстой оболочкой, заполненные кровянистым содержимым.")
	wait(lt)
	sampSendChat("Ожог 4 степени — это полная гибель всех слоев кожи, включая подкожно-жировую клетчатку,..")
	wait(lt)
	sampSendChat("...а также и нижележащих тканей — мышц, сухожилий, костей.")
	wait(lt)
	sampSendChat("Первые действия для нейтрализации термических ожогов:")
	wait(lt)
	sampSendChat("к месту повреждений приложить сухой лед или использовать холодную воду;")
	wait(lt)
	sampSendChat("обработать поврежденные участки тела мазью от ожогов;")
	wait(lt)
	sampSendChat("в случае серьезных травм обратиться вызвать скорую.")
	wait(lt)
	sampSendChat("Нейтрализация химических ожогов:")
	wait(lt)
	sampSendChat("промыть пораженное место сильным потоком воды.")
	wait(lt)
	sampSendChat("обработать сухой салфеткой")
	wait(lt)
	sampSendChat("нанести стерильную антисептическую повязку.")
	wait(lt)
	sampSendChat("Спасибо за прослушивание, на этом моя лекция завершена.")
end

function medAntiSep() -- Антисептические средства
	sampSendChat('Здравствуйте уважаемые сотрудники, сегодня расскажу лекцию на тему "Антисептические средства".')
	wait(ltt)
	sampSendChat("Антисептические средства – это вещества, которые обладают противомикробным действием")
	wait(lt)
	sampSendChat("Наиболее распространенными антисептиками в повседневном применении можно назвать...")
	wait(lt)
	sampSendChat("...спиртовый раствор йода и бриллиантовый зеленый.")
	wait(lt)
	sampSendChat("Которые применяются для обработки поверхностных ран, ссадин и царапин.")
	wait(lt)
	sampSendChat("При продолжительном воздействии антисептиков и антибиотиков бактерии могут эволюционировать...")
	wait(lt)
	sampSendChat("...до точки, когда они больше не страдают от этих веществ.")
	wait(lt)
	sampSendChat("Антисептики без спирта можно использовать как дополнительное средство для гигиены.")
	wait(lt)
	sampSendChat("Обрабатывать руки средством следует не менее 30 секунд. В противном случае...")
	wait(lt)
	sampSendChat("...вирусы и бактерии выживают.")
	wait(lt)
	sampSendChat("Рекомендуется особенно тщательно обрабатывать зону под ногтями.")
	wait(lt)
	sampSendChat("Спасибо за прослушивание, на этом моя лекция завершена.")
end

function medAntibio() -- Антибиотики
	sampSendChat('Здравствуйте уважаемые сотрудники, хотел бы вам рассказать лекцию на тему "Антибиотики".')
	wait(ltt)
	sampSendChat("Антибиотики — антибактериальные лекарственные препараты из группы антимикробных препаратов.")
	wait(lt)
	sampSendChat("Природные и синтетические антибиотики широко применяются в качестве препаратов для лечения инфекций.")
	wait(lt)
	sampSendChat("Они не действуют против вирусных инфекций, однако существуют противогрибковые...")
	wait(lt)
	sampSendChat("...и антипротозойные антибиотики.")
	wait(lt)
	sampSendChat("Антибиотики могут убивать микроорганизмы или останавливать их размножение,..")
	wait(lt)
	sampSendChat("...позволяя естественным защитным механизмам их устранять.")
	wait(lt)
	sampSendChat("Огромное разнообразие антибиотиков и видов их воздействия на организм человека явилось причиной...")
	wait(lt)
	sampSendChat("...классифицирования и разделения противомикробных препаратов на группы.")
	wait(lt)
	sampSendChat("бактериостатические - бактерии остаются живы, но не в состоянии размножаться,")
	wait(lt)
	sampSendChat("бактерицидные - бактерии погибают, а затем выводятся из организма")
	wait(lt)
	sampSendChat("Одно из основных применений антибиотиков - лечение таких распространенных...")
	wait(lt)
	sampSendChat("...болезней как пневмония, сифилиса и туберкулеза.")
	wait(lt)
	sampSendChat("У некоторых людей имеется аллергия к пенициллинам и другим препаратам-антибиотикам.")
	wait(lt)
	sampSendChat("Спасибо за прослушивание, на этом моя лекция завершена.")
end

function medOtmor() -- Отморожение
	sampSendChat('Отморожение - это состояние, вызванное замерзанием тканей из-за длительного...')
	wait(lt)
	sampSendChat("...воздействия низких температур на организм.")
	wait(ltt)
	sampSendChat("Оно может возникнуть при продолжительном нахождении на холоде без достаточной защиты")
	wait(lt)
	sampSendChat("особенно в крайних точках тела, таких как конечности, нос, уши и лицо.")
	wait(lt)
	sampSendChat("Отморожение может иметь разные степени тяжести, от легкого до тяжелого.")
	wait(lt)
	sampSendChat("Степени отморожения:")
	wait(lt)
	sampSendChat("Первая степень: поверхностное отморожение кожи, проявляющееся покраснением,..")
	wait(lt)
	sampSendChat("...отеком, онемением и зудом. Кожа остается мягкой и упругой.")
	wait(lt)
	sampSendChat("Вторая степень: глубокое отморожение кожи, сопровождающееся появлением пузырей, язв")
	wait(lt)
	sampSendChat("некроза и синюшного оттенка кожи. Кожа может быть затвердевшей и болезненной.")
	wait(lt)
	sampSendChat("Третья степень: повреждение всех слоев кожи, а также подлежащих тканей, таких как мышцы,..")
	wait(lt)
	sampSendChat("...сухожилия и кости.")
	wait(lt)
	sampSendChat("Отмороженная ткань становится черной или темно-синей, может быть безжизненной и безболезненной.")
	wait(lt)
	sampSendChat("Первая медицинская помощь при отморожении:")
	wait(lt)
	sampSendChat("Переместите пострадавшего в теплое место.")
	wait(lt)
	sampSendChat("Отнесите его в помещение с более высокой температурой,..")
	wait(lt)
	sampSendChat("...чтобы избежать дальнейшего воздействия холода.")
	wait(lt)
	sampSendChat("Снимите смоченную или тугую одежду.")
	wait(lt)
	sampSendChat("Одежда может способствовать замерзанию тканей, поэтому необходимо удалить мокрую одежду")
	wait(lt)
	sampSendChat("или снять ту, которая может оказывать давление на отмороженные участки тела.")
	wait(lt)
	sampSendChat("Погрейте отмороженные участки теплой (но не горячей) водой.")
	wait(lt)
	sampSendChat("Можно также использовать теплое покрывало или обернуть пострадавшего в теплые одеяло.")
	wait(lt)
	sampSendChat("Не используйте горячую воду, греющие подушки, обогреватели или другие источники интенсивного тепла")
	wait(lt)
	sampSendChat("так как это может привести к ожогам.")
	wait(lt)
	sampSendChat("Не трите отмороженные участки. Это может вызвать еще боль")
	wait(lt)
	sampSendChat("Спасибо за прослушивание.")
end

function medPeredoza() -- Передозировка
	sampSendChat('Передозировка - это состояние, когда человек принимает более высокую дозу лекарства')
	wait(lt)
	sampSendChat("чем рекомендуется или без назначения врача.")
	wait(ltt)
	sampSendChat("Это может привести к серьезным последствиям, включая остановку дыхания,..")
	wait(lt)
	sampSendChat("...судороги, потерю сознания и даже смерть.")
	wait(lt)
	sampSendChat("Если вы подозреваете, что кто-то переоценил дозу лекарства, то нужно:")
	wait(lt)
	sampSendChat("сразу вызвать скорую помощь и сообщить об этом медицинскому персоналу")
	wait(lt)
	sampSendChat("также стоит попытаться выяснить, какой вид лекарства был принят, сколько и когда его было принято")
	wait(lt)
	sampSendChat("Если человек находится в бессознательном состоянии и не дышит,..")
	wait(lt)
	sampSendChat("...необходима немедленная кардиопульмональная реанимация.")
	wait(lt)
	sampSendChat("Если человек при сознании, то необходимо обеспечить ему поддерживающую терапию")
	wait(lt)
	sampSendChat("например, изотонический раствор для устранения дегидратации или препараты для лечения отравления.")
	wait(lt)
	sampSendChat("Ни в коем случае не стоит пытаться вызывать рвоту,")
	wait(lt)
	sampSendChat("давать противоядие или какой-либо другой препарат без консультации с медицинским специалистом")
	wait(lt)
	sampSendChat("Это может только ухудшить ситуацию и нанести вред здоровью.")
	wait(lt)
	sampSendChat("Спасибо за прослушивание.")
end

-- LIC
function licDress() -- Дресс-код
	sampSendChat("Здраствуйте сотрудники, я вам сегодня проведу лекцию на тему дресс код.")
	wait(ltt)
	sampSendChat("Вы можете носить только очки, фотоаппарат и маску от болезней.")
	wait(lt)
	sampSendChat("Также Вы имеете полное право носить на плече вашего животного.")
	wait(lt)
	sampSendChat("Главное, чтобы он был привит и не мешал работе.")
	wait(lt)
	sampSendChat("В случае нарушения дресс-кода вы получите наказание.")
	wait(lt)
	sampSendChat("Лекция окончена, Вы свободны.")
end

function licCar() -- Исп. рабочего т/с
	sampSendChat("Здравствуйте, Уважаемые сотрудники.")
	wait(ltt)
	sampSendChat('Сейчас я расскажу Вам лекцию на тему "Служебный транспорт". ')
	wait(lt)
	sampSendChat("Также перед тем как Вы возьмёте транспорт, вы должны")
	wait(lt)
	sampSendChat("предупредить об этом в рацию. В случае нарушения этого, Вы получите наказание.")
	wait(lt)
	sampSendChat("Автомобиль Шкода с должности Экзаменатор,")
	wait(lt)
	sampSendChat("а автомобиль Тойота Авенс с должности Старшего Инструктора.")
	wait(lt)
	sampSendChat("Всем спасибо, лекция окончена, Вы свободны.")
end

function licVPO() -- ВПО
	sampSendChat("Здраствуйте сотрудники я вам сегодня проведу лекцию на тему ВПО.")
	wait(ltt)
	sampSendChat("ВПО — это Военно Призывной отдел.")
	wait(lt)
	sampSendChat("Суть этого отдела — выезжать на призывы в Армию, ТСР, МВД.")
	wait(lt)
	sampSendChat("Если кто-то не понял, то когда вы на призыве, например в Армии,...")
	wait(lt)
	sampSendChat("...стоите и у призывника нету какой-либо лицензии, то вы ему выдаете.")
	wait(lt)
	sampSendChat("После окончения собеседования, вы едете назад в автошколу.")
	wait(lt)
	sampSendChat("Лекция окончена, Вы свободны.")
end

-- SMI
function smiRadio() -- Рация
	sampSendChat('Рация — это источник связи с коллегами организации,')
	wait(ltt)
	sampSendChat("Для передачи важной информации.")
	wait(lt)
	sampSendChat("В рации звучит такая информация, как доклады с постов и тому подобное.")
	wait(lt)
	sampSendChat("В рации запрещены всякие оскорбления, мат, угрозы.")
	wait(lt)
	sampSendChat("В рацию запрещено сообщать бессмысленные сообщения.")
	wait(lt)
	sampSendChat("За нарушение данных правил вы будете наказаны.")
	wait(lt)
	sampSendChat("На этом лекция окончена.")
end

function smiDress() -- Дресс-код
	sampSendChat('Дресс-код должен соблюдаться всеми сотрудниками.')
	wait(ltt)
	sampSendChat("Разрешается снимать рабочую форму в обеденное время.")
	wait(lt)
	sampSendChat("Разрешено носить маски для коронавируса.")
	wait(lt)
	sampSendChat("Разрешено носить любые виды часов.")
	wait(lt)
	sampSendChat("Также, разрешено носить очки со стеклянными линзами, тёмные очки...")
	wait(lt)
	sampSendChat("И очки с разноцветными линзами.")
	wait(lt)
	sampSendChat("За нарушение дресс-кода сотруднику будет выдано устное предупреждение.")
	wait(lt)
	sampSendChat("При последующем нарушении - выговор.")
	wait(lt)
	sampSendChat("На этом лекция закончена, благодарю за внимание.")
end

function smiCar() -- Исп. рабочего т/с
	sampSendChat('Здравствуйте уважаемые сотрудники радиостанции г.Арзамаса.')
	wait(lt)
	sampSendChat('Сейчас я проведу лекцию на тему "Пользование рабочего транспорта".')
	wait(ltt)
	sampSendChat("Брать служебный транспорт без спроса Руководящего состава - запрещено.")
	wait(lt)
	sampSendChat("Также, при разрешении, запрещено использовать служебный транспорт в личных целях.")
	wait(lt)
	sampSendChat("В противном случае, Вы будете уволены.")
	wait(lt)
	sampSendChat("Так же брать любое транспорте средство Начинающему работнику строго запрещено.")
	wait(lt)
	sampSendChat("На этом лекция окончена. Всем спасибо.")
end

function smiSub() -- Субординация
	sampSendChat('Здравствуйте уважаемые сотрудники радиостанции г.Арзамаса.')
	wait(lt)
	sampSendChat('Сейчас я проведу лекцию на тему "Субординация"')
	wait(ltt)
	sampSendChat("Субординацию должны соблюдать все сотрудники, как начинающий работник, так и Директор.")
	wait(lt)
	sampSendChat('К сотрудникам либо жителям штата нужно обращаться строго на "Вы"')
	wait(lt)
	sampSendChat("За несоблюдение субординации Вы можете получить выговор.")
	wait(lt)
	sampSendChat("На этом лекция подошла к концу. Спасибо за внимание.")
end

function smiUstav() -- Устав
	sampSendChat('Сейчас будет лекция на тему "Устав".')
	wait(ltt)
	sampSendChat("Каждый сотрудник радиоцентров обязан знать и соблюдать данный устав.")
	wait(lt)
	sampSendChat("Вот несколько пунктов из устава, которые вы обязаны знать:")
	wait(lt)
	sampSendChat("В рабочие часы сотрудникам НГ-А запрещено посещать места дополнительного заработка,..")
	wait(lt)
	sampSendChat("...как в форме, так и без.")
	wait(lt)
	sampSendChat("В том числе Автобазара и Центрального Рынка.")
	wait(lt)
	sampSendChat("Рабочий день длится с 12:00 до 21:00 ежедневно.")
	wait(lt)
	sampSendChat("Обеденный перерыв с 15:00 до 16:00")
	wait(lt)
	sampSendChat("На этом лекция закончена, благодарю за внимание.")
end

-- ARMY
function armyRuleStroy() -- Правила в строю
    sampSendChat("Здравствуйте, Уважаемые сотрудники.")
    wait(lt)
    sampSendChat('Сегодня лекция будет на тему "Поведение в строю"')
    wait(ltt)
    sampSendChat('И так... В строю строго запрещено:')
    wait(lt)
    sampSendChat('Использование мобильных средств и рации.')
    wait(lt)
    sampSendChat('Спать и находится в строю без снаряжения.')
    wait(lt)
    sampSendChat('Самовольно покидать строй и вести разговоры.')
    wait(lt)
    sampSendChat('Использовать оружие, вести огонь из строя.')
    wait(lt)
    sampSendChat("Запрещено покидать строй без разрешения.")
    wait(lt)
    sampSendChat("Если к вам обращаются давайте чёткий и быстрый ответ.")
    wait(lt)
    sampSendChat("За плохое поведение в строю вы лишитесь своих погон.")
    wait(lt)
    sampSendChat("Лекция окончена! Спасибо за внимание!")
end

function armyNewB()-- Лекция новобранцам.
    sampSendChat("Здравия желаю, бойцы!")
    wait(lt)
    sampSendChat("Отныне Вы бойцы которые служат в армии Северной Республики!")
    wait(ltt)
    sampSendChat("Ваша задача - охранять базу и стоять на постах!")
    wait(lt)
    sampSendChat("Вам запрещено брать какой-либо транспорт без разрешения офицера!")
    wait(lt)
    sampSendChat("Каждый боец обязан соблюдать субординацию!")
    wait(lt)
    sampSendChat("Также в армии нету таких слова как: «Да» «Нет» «Извините» «Пожалуйста»")
    wait(lt)
    sampSendChat("В армии используются эти слова: «Так точно» «Никак нет» «Виноват» /s«Разрешите» «Товарищ»!")
    wait(lt)
    sampSendChat("Каждый кто стоит на посту обязан просить паспорт или удостоверение при въезде...")
    wait(lt)
		sampSendChat("...у бойца и офицера не зависимо от звания!")
		wait(lt)
    sampSendChat("Вы не имеете право покидать пост не предупредив в рацию, и не предъявив причину!")
    wait(lt)
    sampSendChat("Если вы покинете пост без доклада в рацию, вы будете отстранены!")
    wait(lt)
    sampSendChat("Также Вы не имеете права открывать огонь без предупреждения!")
    wait(lt)
    sampSendChat("За нарушение этих правил вы получите выговор или увольнение!")
    wait(lt)
    sampSendChat("На этом лекция окончена!")
end

function armySamovolka() -- самоволка
    sampSendChat("Здравия бойцы армии!")
    wait(lt)
    sampSendChat("Сейчас будет лекция на тему 'Самоволка'")
    wait(ltt)
    sampSendChat("Во первых, базу рядовым и ефрейтора покидать абсолютно запрещено!")
    wait(lt)
    sampSendChat("Покидать базу можно только со звания Сержанта, но и то в 21:00.")
    wait(lt)
    sampSendChat("Если вас кто-то увидит и расскажет мне ,то вас сразу же уволят и занесут в ЧС Армии на 3 месяца.")
    wait(lt)
    sampSendChat("Думаю вы поняли меня, всем спасибо!")
end

function armySub() -- субординация
    sampSendChat("Здравия желаю, бойцы!")
    wait(lt)
    sampSendChat("Сейчас я проведу лекцию на тему Субординация")
    wait(ltt)
    sampSendChat("Субординация - это неотъемлемая часть армии.")
    wait(lt)
    sampSendChat("Вы должны полностью перейти на общение армии.")
    wait(lt)
    sampSendChat("Строго запрещено использовать такие слова, как...")
    wait(lt)
    sampSendChat("Здравствуйте, Да, Нет, Можно и так далее...")
    wait(lt)
    sampSendChat("Разрешены такие слова, как...")
    wait(lt)
    sampSendChat("Так точно, Никак нет, Разрешите, Здравия желаю и так далее...")
    wait(lt)
    sampSendChat("Так же вы должны обращаться к старшему составу строго по званию, например Здравия желаю, т. Генерал")
    wait(lt)
    sampSendChat("Обращаться к гражданам нужно на Вы")
    wait(lt)
    sampSendChat("На этом лекция на тему Субординация окончена!")
end

function armyKPP() -- Правило обращения с гражданами на КПП.
    sampSendChat("Здравия желаю, бойцы.")
    wait(lt)
    sampSendChat("Сейчас я проведу для вас лекцию на тему Правило обращение с гражданами на КПП")
    wait(ltt)
    sampSendChat("Как только гражданин подходит к КПП вы должны подойти к нему и спросить его цель прибытия.")
    wait(lt)
    sampSendChat("Если её нету вы должны попросить его отойти от КПП на 30 метров.")
    wait(lt)
    sampSendChat("Если гражданин не хочет отходить и грубит вы должны заламать руки и отвести его от КПП.")
    wait(lt)
    sampSendChat("Как только гражданин достаёт оружие вы должны напасть на него, не стреляя.")
    wait(lt)
    sampSendChat("Если же вы далеко, вы должны спрятаться за укрытие и вызвать полицию.")
    wait(lt)
    sampSendChat("Если нету телефона, то доложить по рации и начать стрелять по ногам.")
    wait(lt)
    sampSendChat("На этом лекция на тему Правило обращения с гражданами на КПП")
end

function armyStroy() -- строевая подготовка
    sampSendChat("Здравия желаю, уважаемые бойцы армии Северной Республики")
    wait(lt)
    sampSendChat("Сейчас я вам проведу лекцию на тему Строевая подготовка")
    wait(ltt)
    sampSendChat("Для начала все бойцы должны построиться в ровную шеренгу")
    wait(lt)
    sampSendChat("Самая первая команда: Равняйсь!")
    wait(lt)
    sampSendChat("После такой команды все, кроме первого, должны повернуть голову на направляющего")
    wait(lt)
    sampSendChat("Следующая команда: Смирно!")
    wait(lt)
    sampSendChat("Вы поворачиваете голову в исходное положение и неподвижно стоите")
    wait(lt)
    sampSendChat("Команда “Вольно!” дает возможность задать вопросы командиру")
    wait(lt)
    sampSendChat("После этого командир на усмотрение произносит такие команды, как:")
    wait(lt)
    sampSendChat("Налево!, Направо!, Кругом!, Шагом марш!, и тому прочее")
    wait(lt)
    sampSendChat("Самое главное – это слушать приказы командира")
    wait(lt)
    sampSendChat("Лекция на тему Строевая подготовка окончена")
end

function armyCHS() -- Как правильно действовать при нападение на ВЧ
    sampSendChat("Здравия желаю, уважаемые бойцы армии Северной Республики")
    wait(lt)
    sampSendChat("Сегодня я вам проведу лекцию на тему Как правильно действовать при нападение на ВЧ")
    wait(ltt)
    sampSendChat("В первую очередь, вам надо убедиться, что люди напали на базу")
    wait(lt)
    sampSendChat("Если бандиты в масках начали атаковать вас - это нападание")
    wait(lt)
    sampSendChat("У вас должно быть в руках обязательно AK-47 и Deagle , а также иметь бронежилет на себе")
    wait(lt)
    sampSendChat("Первый отпор должны дать вы. Но если вы не справляетесь...")
    wait(lt)
    sampSendChat("...в рацию вы должны сообщить о нападении на Воинскую Часть")
    wait(lt)
    sampSendChat("Запрещено убегать от выстрелов, обратно в казарму или на завод")
    wait(lt)
    sampSendChat('Лекция на тему "Как правильно действовать при нападение на ВЧ" окончена!')
end
