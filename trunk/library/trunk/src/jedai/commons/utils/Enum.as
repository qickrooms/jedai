/*
Copyright © 2007 Modulous, LLC, All Rights Reserved

This source file is not open source and cannot be used or reproduced without
the written permision of Modulous, LLC.

The Modulous Software is provided by Modulous on an "AS IS" basis.  Modulous 
MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED
WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE, REGARDING THE Modulous SOFTWARE OR ITS USE AND OPERATION ALONE OR IN
COMBINATION WITH YOUR PRODUCTS.

IN NO EVENT SHALL Modulous BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR DISTRIBUTION
OF THE Modulous SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF CONTRACT, TORT
(INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF Modulous HAS BEEN
ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

package jedai.commons.utils
{
	public class Enum
	{
		private static var id:Number = 0;
		
		private var index : int;
		private var value : *;		
		
		
		/**
		 * 
		 * @param value:
		 */
		public function Enum( _value:* = null )
		{
			this.index = Enum.id++;
			this.value = _value;
		}	
			
		
		/**
		 * 
		 * @return 
		 */
		public function getValue() : int 
		{
			return this.index;
		}
		
		
		
		/**
		 * 
		 * @return
		 */
		public function getObject() : *
		{
			return this.value;
		}		
	}
}