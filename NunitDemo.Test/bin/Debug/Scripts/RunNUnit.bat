echo Starting of the file on %date% at %time%
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "YY=%dt:~2,2%" & set "YYYY=%dt:~0,4%" & set "MM=%dt:~4,2%" & set "DD=%dt:~6,2%"
set "HH=%dt:~8,2%" & set "Min=%dt:~10,2%" & set "Sec=%dt:~12,2%"

set "datestamp=%YYYY%%MM%%DD%" & set "timestamp=%HH%%Min%%Sec%"
set "fullstamp=%YYYY%-%MM%-%DD%_%HH%-%Min%-%Sec%"

cd %~dp0
echo "Running tests"
("D:\Project2017\PIM Generic Tools\Dev\Prft.inRiver.Outbound\packages\NUnit.ConsoleRunner.3.7.0\tools\nunit3-console.exe" /work:"D:\Project2017\PIM Generic Tools\Dev\Prft.inRiver.Outbound\Prft.inRiver.Nunit.Test\Reporting"  --out:"TestResult.txt" "D:\Project2017\PIM Generic Tools\Dev\Prft.inRiver.Outbound\Prft.inRiver.Nunit.Test\bin\Release\Prft.inRiver.Nunit.Test.dll")

echo "Running report"
("D:\Project2017\PIM Generic Tools\Dev\Prft.inRiver.Outbound\packages\ReportUnit.1.2.1\tools\ReportUnit.exe" "D:\Project2017\PIM Generic Tools\Dev\Prft.inRiver.Outbound\Prft.inRiver.Nunit.Test\Reporting" "D:\Project2017\PIM Generic Tools\Dev\Prft.inRiver.Outbound\Prft.inRiver.Nunit.Test\Reporting\Result")

echo "copying report file to folder"
xcopy "D:\Project2017\PIM Generic Tools\Dev\Prft.inRiver.Outbound\Prft.inRiver.Nunit.Test\Reporting\Result\*.html" "D:\Project2017\PIM Generic Tools\Dev\Prft.inRiver.Outbound\Prft.inRiver.Nunit.Test\Reporting\Result\%fullstamp%\*.html"

