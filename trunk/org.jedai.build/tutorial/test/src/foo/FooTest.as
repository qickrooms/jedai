package foo
{
    import flexunit.framework.TestCase;
    import flexunit.framework.TestSuite;

    public class FooTest
        extends TestCase
    {
        public function test1():void
        {
            assertEquals("Making sure 42 is 42", 42, 42);
        }
    }
}
