"..\..\..\..\packages\OpenCover.4.6.519\tools\OpenCover.Console.exe" -target:"..\..\..\..\packages\NUnit.ConsoleRunner.3.7.0\tools\nunit3-console.exe" -targetargs:"/work:Reporting  --out:TestResult.txt ..\NunitDemo.Test.dll" -filter:"+[*]*" -excludebyattribute:"System.CodeDom.Compiler.GeneratedCodeAttribute" -register:user -output:"CodeCoverageResult.xml"

"..\..\..\..\packages\ReportGenerator.3.1.0\tools\ReportGenerator.exe" "-reports:CodeCoverageResult.xml" "-targetdir:CodeCoverageReport"

"..\..\..\..\packages\ReportUnit.1.2.1\tools\ReportUnit.exe" "Reporting" "Reporting\Result"

cmd /k
