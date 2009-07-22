package
{
    import flexunit.framework.TestCase;
    import flash.data.SQLConnection;

    public class SampleTest extends TestCase
    {
        public function testTrue():void
        {
            assertEquals(true, true);
        }

        public function testAirClass():void
        {
            var conn:SQLConnection = new SQLConnection();
            assertNotNull(conn);
        }
    }
}
