package { 

import flexunit.framework.*;
import foo.FooTest;

public class FlexUnitAllTests 
{
   public static function suite() : TestSuite
   {
      var testSuite:TestSuite = new TestSuite();
      testSuite.addTestSuite(FooTest);
      return testSuite;
   }
}
}
