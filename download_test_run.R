library("RUnit")

# Runs the tests suite
t.suite = defineTestSuite("download.web.data", ".",
                          testFileRegexp = ".+_test.R$", 
                          testFuncRegexp = "^test.+")
if(!isValidTestSuite(t.suite)){
  print("Invalid test suite created!")
}
t.results = runTestSuite(t.suite)
printTextProtocol(t.results)