package foo
{
    import flexunit.framework.TestCase;
    import flexunit.framework.TestSuite;

    public class FooTest
        extends TestCase
    {
        public var fooObj:Foo;

        public function FooTest(methodName : String = null)
        {
            super(methodName);
        }
        
        override public function setUp():void
        {
            fooObj = new Foo();
        }
        
        public function test1():void
        {
            assertEquals("making sure we've got 42", 42, fooObj.answer);
        }
    }
}
