package bar
{
    import flexunit.framework.TestCase;
    import flexunit.framework.TestSuite;

    public class BarTest
        extends TestCase
    {
        public function test1():void
        {
            assertEquals("Making sure 42 is still 42", 42, 42);
        }
    }
}
