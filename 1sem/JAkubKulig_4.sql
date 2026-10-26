USE s109070

--2. Poka¿ nazwiska wszystkich osób, które rozpoczynaj¹ siê na literê K. Nazwiska wyœwietl pisane du¿ymi literami
SELECT UPPER(p.LastName)
FROM Person p
WHERE p.LastName LIKE 'K%'

--3. Wyœwietl listê imion i nazwisk osób w tabeli Person. Poka¿ tak¿e kolumnê, która  zliczy iloœæ znaków w imieniu. Posortuj wynik rosn¹co wed³ug iloœci wyliczonych znaków
SELECT DISTINCT p.FirstName, p.LastName, LEN(p.FirstName) liczba_znakow
FROM Person p
ORDER BY liczba_znakow

--4. Wyœwietl listê nazwisk, które zawieraj¹ sylabê „on”. Wyœwietl tak¿e informacjê, na której literze nazwiska rozpoczyna siê sylaba, ile jest liter w nazwisku. Wynik posortuj rosn¹co wg pozycji litery.
SELECT DISTINCT p.LastName, CHARINDEX('on',p.LastName) znak
FROM Person p
WHERE p.LastName LIKE '%on%'
ORDER BY znak

--5. Wyœwietl listê nazwisk, które koñcz¹ siê na „on”. Wykorzystaj funkcjê RIGHT()
SELECT DISTINCT p.LastName
FROM Person p
WHERE RIGHT(p.LastName,2) ='on'
ORDER BY p.LastName

--6. Przygotuj login do nowego systemu dla wszystkich osób w Twojej bazie. Login ma siê sk³adaæ z pierwszych dwóch znaków imienia i pierwszych trzech znaków nazwiska. Login powinien byæ pisany ma³ymi literami. Wyœwietl identyfikator osoby, imiê, nazwisko oraz przygotowany login. Wykorzystaj w zadaniu funkcjê SUBSTRING()
SELECT p.FirstName, p.LastName,
LOWER (SUBSTRING(p.FirstName, 1,2) + SUBSTRING(p.LastName, 1,3)) loginy
FROM Person p

--7. Wykonaj powy¿sze zadanie, ale wykorzystaj w zadaniu funkcjê LEFT()
SELECT p.FirstName, p.LastName,
LOWER (LEFT(p.FirstName, 2) + LEFT(p.LastName, 3)) 'login'
FROM Person p

-- 8. Musisz zaszyfrowaæ 4-literowe nazwiska osób, które zawieraj¹ literê „a”. Wyœwietl nazwisko oraz nazwisko zaszyfrowane w nastêpuj¹cy sposób: o Ka¿da litera „a” jest zamieniona na ci¹g „si”.  Utworzony szyfr jest zwrócony wspak (REVERSE())  Ca³oœæ przekszta³æ na ma³e litery."
SELECT p.LastName,
		LOWER(REVERSE(REPLACE(p.LastName, 'a', 'si'))) AS Zaszyfrowane
FROM Person p
WHERE LEN(p.LastName) = 4
	AND p.LastName LIKE '%a%'; 

--9. Wyœwietl dwie kolumny: o Pierwsza ma zawieraæ identyfikator osoby. o Druga ma nazywaæ siê „Imiê i nazwisko” i zawieraæ po³¹czone wartoœci z pól  Imiê, drugie imiê oraz nazwisko
SELECT 
		p.FirstName +''+ ISNULL(p.MiddleName+'','')+p.LastName AS [Imiê i Nazwisko]
FROM Person p;

--10. Wyœwietl nazwy grup roboczych, czyli fragment LoginID znajduj¹cy siê przed znakiem '\', dla wszystkich pracowników
SELECT DISTINCT	
		LEFT(e.LoginID,CHARINDEX('\',e.LoginID) - 1) AS GroupName
FROM Employee e
WHERE CHARINDEX('\', e.LoginID)>0;

--11. Wyœwietl loginy pracowników pomijaj¹c nazwê grupy roboczej (tabela Employess). UWAGA! Z DISTINCT mo¿emy od razu zweryfikowaæ czy nie ma powtórzeñ loginu. Liczba wierszy powinna byæ taka sama jak w tabeli Employee.
SELECT
		CASE
			WHEN CHARINDEX('\', LoginID) > 0
				THEN SUBSTRING(LoginID,CHARINDEX('\', LoginID) + 1, LEN(LoginID))
			ELSE LoginID
		END AS Login
FROM Employee;

--12. Pobierz pierwsze 5 znaków z JobTitle pracownika
SELECT LEFT(JobTitle, 5) AS JobTitle_firstfive
FROM Employee;

--13. Pobierz ostatnie 3 znaki z JobTitle.
SELECT RIGHT(JobTitle, 3) AS JobTitle_last3
FROM Employee;

--14. Wyodrêbnij drugie s³owo z JobTitle (u¿yj CHARINDEX() i SUBSTRING()).
SELECT 
		CASE
			WHEN CHARINDEX(' ',e.JobTitle) = 0 THEN NULL
			ELSE
				CASE
					WHEN CHARINDEX(' ',JobTitle,CHARINDEX(' ',JobTitle) + 1) = 0
						THEN SUBSTRING(JobTitle, CHARINDEX(' ',JobTitle) + 1, LEN(JobTitle))
					ELSE SUBSTRING(JobTitle, CHARINDEX(' ',JobTitle) + 1, CHARINDEX(' ',JobTitle,CHARINDEX(' ',JobTitle) + 1) - CHARINDEX(' ',JobTitle) - 1)
				END
		END AS secondWord
FROM Employee e;
--15. Zamieñ wszystkie wyst¹pienia s³owa "Manager" na "Kierownik" w JobTitle.
SELECT
		REPLACE(e.JobTitle,'Manager','Kierownik') AS JobTitle_PL
FROM Employee e;

--16. Po³¹cz FirstName i LastName z tabeli Person w jeden ci¹g przy u¿yciu CONCAT().
SELECT CONCAT(p.FirstName, p.LastName) AS no_space
FROM Person p;

--17. Po³¹cz FirstName i LastName z separatorem - przy u¿yciu CONCAT_WS().
SELECT  CONCAT_WS(' ',p.FirstName,p.LastName) AS FullName
FROM Person p;

--18. Usuñ spacje z obu stron JobTitle (TRIM), a nastêpnie sprawdŸ d³ugoœæ napisu (LEN).
SELECT LEN(TRIM(e.JobTitle)) AS JobTitle_trimmed
FROM Employee e;

--19. Odwróæ tekst JobTitle (REVERSE) i wyœwietl go du¿ymi literami.
SELECT UPPER(REVERSE(e.JobTitle)) AS JobTitle_reversed_upper
FROM Employee e;

--20. Wstaw tekst " - Senior" po 10 znaku JobTitle (STUFF).
SELECT STUFF(e.JobTitle, 11, 0,'-Senior') AS JobTitle_senior
FROM Employee e;

--21. SprawdŸ, na którym miejscu wystêpuje s³owo "Engineer" w JobTitle (CHARINDEX).
SELECT CHARINDEX('Engineer', e.JobTitle) AS Engineer_pos
FROM Employee e;

--22. Wyœwietl tylko nazwiska (LastName) zaczynaj¹ce siê na "S".
SELECT p.LastName
FROM Person p
WHERE LastName Like 'S%';

--23. Wyœwietl pracowników, których imiê zawiera literê "a".
SELECT p.FirstName
FROM Person p
WHERE FirstName Like '%a%';

--24. Wyœwietl tylko drugie s³owo z JobTitle (jeœli jest).
SELECT 
		CASE
			WHEN CHARINDEX(' ',e.JobTitle) = 0 THEN NULL
			WHEN CHARINDEX(' ',JobTitle,CHARINDEX(' ',JobTitle) + 1) = 0
					THEN SUBSTRING(JobTitle, CHARINDEX(' ',JobTitle) + 1, LEN(JobTitle))
				ELSE SUBSTRING(JobTitle, CHARINDEX(' ',JobTitle) + 1, CHARINDEX(' ',JobTitle,CHARINDEX(' ',JobTitle) + 1) - CHARINDEX(' ',JobTitle) - 1)
		END AS secondWord
FROM Employee e;
--25. Dodaj znak "#" na pocz¹tku FirstName i wyœwietl (konkatenacja).
SELECT '#' + p.FirstName AS FirstName_tagged
FROM Person p;

--26. Usuñ wszystkie wyst¹pienia litery "e" z JobTitle.
SELECT REPLACE(REPLACE(e.JobTitle, 'e',''),'E','') AS JobTitle_no_e
FROM Employee e;

--27. Wyœwietl wszystkie imiona, których d³ugoœæ jest wiêksza ni¿ 5 znaków.
SELECT p.FirstName
FROM Person p
WHERE LEN(p.FirstName) > 5;

--28. Przytnij JobTitle tak, aby mia³ maksymalnie 10 znaków.
SELECT LEFT(e.JobTitle, 10) AS JobTitle_trim10
FROM Employee e;

--29. Wyodrêbnij nazwisko (LastName) bez trzech pierwszych liter.
SELECT SUBSTRING(p.LastName, 4, LEN(p.LastName)) AS LastName_no3
FROM Person p;

--30. Dodaj trzy spacje miêdzy FirstName a LastName (konkatenacja z ' ').
SELECT p.FirstName + '   ' + p.LastName AS Name_with_space
FROM Person p;


--31. Zamieñ spacje w JobTitle na znak podkreœlenia _.
SELECT e.JobTitle,
		REPLACE(e.JobTitle, ' ', '_') AS JobTitle_no_space
FROM Employee e;

--32. Odwróæ imiê (FirstName) i nazwisko (LastName). Po³¹cz je i wyœwietl ma³ymi literami.
SELECT CONCAT( LOWER(REVERSE(p.FirstName )),LOWER(REVERSE(p.LastName))) AS Lower_name
FROM Person p;

--33. U¿yj STR() aby wyœwietliæ EmployeeID jako tekst.
SELECT e.BusinessEntityID AS EmployeeID,
       STR(e.BusinessEntityID) AS EmployeeID_text
FROM Employee e;

--34. Wyci¹gnij inicja³y pracownika (pierwsza litera FirstName i LastName).
SELECT 
       LEFT(p.FirstName, 1) + LEFT(p.LastName, 1) AS Initials
FROM Person p;

--35. Po³¹cz FirstName, MiddleName i LastName nawet gdy MiddleName jest NULL.
SELECT CONCAT_WS(' ', p.FirstName, p.MiddleName, p.LastName) AS FullName
FROM Person p;


--36. Wyœwietl wszystkich pracowników, których nazwisko koñczy siê na literê "n".
SELECT  p.LastName
FROM Person p
JOIN Employee e ON p.BusinessEntityID = e.BusinessEntityID
WHERE p.LastName LIKE '%n';

--37. Przytnij wszystkie bia³e znaki z pocz¹tku i koñca MiddleName.
SELECT TRIM(p.MiddleName) AS MiddleName_trimmed
FROM Person p;

--38. Zwróæ tylko imiona, w których trzecia litera to "a" (SUBSTRING + warunek).
SELECT p.FirstName
FROM Person p
WHERE SUBSTRING(p.FirstName, 3, 1) = 'a';

--39. Wyœwietl imiê i nazwisko wszystkich osób. Je¿eli osoba posiada przyrostek do nazwiska(suffix) to dopisz go przy nazwisku.
SELECT p.FirstName,
       p.LastName + ISNULL(' ' + p.Suffix, '') AS LastName_with_suffix,
       CONCAT_WS(' ', p.FirstName, p.LastName + ISNULL(' ' + p.Suffix, '')) AS [Imiê i nazwisko]
FROM Person p;
