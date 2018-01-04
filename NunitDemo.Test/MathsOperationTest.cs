using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using NUnit.Framework;

namespace NunitDemo.Test
{
    [TestFixture]
    public class MathsOperationTest
    {
        [Test]
        public void TestAddition()
        {
            MathsOperation mathsOperation = new MathsOperation();
            Assert.AreEqual(3, mathsOperation.Addtion(1, 2));
        }
    }
}
