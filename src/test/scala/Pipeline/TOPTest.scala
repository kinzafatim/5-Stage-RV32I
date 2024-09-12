package Pipeline

import chisel3._
import org.scalatest.FreeSpec
import chiseltest._

class TOPTest extends FreeSpec with ChiselScalatestTester{
   "TOPTest test" in{
       test(new PIPELINE ()){c =>
         c.clock.step(200) 
       }
   }
}