package
{
    import flexunit.framework.*;
    import bar.BarTest;
    import foo.FooTest;

    public class FlexUnitAllTests 
    {
        public static function suite() : TestSuite
        {
            var testSuite:TestSuite = new TestSuite();
            testSuite.addTestSuite(bar.BarTest);
            testSuite.addTestSuite(foo.FooTest);
            return testSuite;
        }
    }
}
