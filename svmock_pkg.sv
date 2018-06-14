//-------------------
// MOCK CLASS MACROS
//-------------------

`define SVMOCK(MOCK,ORIGINAL) \
class MOCK extends ORIGINAL; \
  __mocker __mockers [$]; \
  function bit check(); \
    check = 1; \
    foreach (__mockers[i]) begin \
      check &= __mockers[i].check(); \
    end \
  endfunction \
  function bit clear(); \
    foreach (__mockers[i]) begin \
      __mockers[i].clear(); \
    end \
  endfunction

`define SVMOCK_END endclass


//----------------
// VOID FUNCTIONS
//----------------

`define SVMOCK_VOIDFUNCTION0(NAME) \
  __mocker0 __``NAME = new("NAME", __mockers); \
  function NAME(); \
    __``NAME.Called(); \
    super.NAME(); \
  endfunction

`define SVMOCK_VOIDFUNCTION1(NAME,TYPE0,ARG0) \
  __mocker1 __``NAME = new("NAME", __mockers); \
  function NAME(TYPE0 ARG0); \
    __``NAME.Called(ARG0); \
    super.NAME(ARG0); \
  endfunction

`define SVMOCK_VOIDFUNCTION2(NAME,TYPE0,ARG0,TYPE1,ARG1) \
  __mocker2 __``NAME = new("NAME", __mockers); \
  function NAME(TYPE0 ARG0, TYPE1 ARG1); \
    __``NAME.Called(ARG0, ARG1); \
    super.NAME(ARG0, ARG1); \
  endfunction


//--------------------
// NON-VOID FUNCTIONS
//--------------------

`define SVMOCK_FUNCTION0(NAME,RETURN) \
  function RETURN NAME(); \
    return super.NAME(); \
  endfunction

`define SVMOCK_FUNCTION1(NAME,RETURN,TYPE0,ARG0) \
  function RETURN NAME(TYPE0 ARG0); \
    return super.NAME(ARG0); \
  endfunction

//-------------
// EXPECT CALL
//-------------
`define EXPECT_CALL(OBJ,METHOD) \
  OBJ.__``METHOD

package svmock_pkg;
  class __mocker;
    int timesCnt = 0;
    int signed timesExactlyExp = -1;
    int signed timesAtLeastExp = -1;
    int signed timesAtMostExp = -1;

    function new(string name, ref __mocker __mockers[$]);
      __mockers.push_back(this);
    endfunction


    //-------
    // Times
    //-------

    function void Exactly(int t);
      timesExactlyExp = t;
    endfunction

    function void AtLeast(int t);
      timesAtLeastExp = t;
    endfunction

    function void AtMost(int t);
      timesAtMostExp = t;
    endfunction

    function void Between(int min, int max);
      timesAtLeastExp = min;
      timesAtMostExp = max;
    endfunction


    //----------
    // checking
    //----------

    virtual function bit check();
      check = 1;

      check &= (timesExactlyExp >= 0) ? (timesCnt == timesExactlyExp) : 1;
      check &= (timesAtLeastExp >= 0) ? (timesCnt >= timesAtLeastExp) : 1;
      check &= (timesAtMostExp  >= 0) ? (timesCnt <= timesAtMostExp)  : 1;

      return check;
    endfunction

    virtual function clear();
      timesCnt = 0;
      timesExactlyExp = -1;
      timesAtLeastExp = -1;
      timesAtMostExp = -1;
    endfunction
  endclass

  class __mocker0 extends __mocker;

    function new(string name, ref __mocker __mockers[$]);
      super.new(name, __mockers);
    endfunction

    //--------
    // Called
    //--------

    function void Called();
      timesCnt += 1;
    endfunction
  endclass


  class __mocker1 #(type TYPE0 = int) extends __mocker;

    function new(string name, ref __mocker __mockers[$]);
      super.new(name, __mockers);
    endfunction

    //--------
    // Called
    //--------

    TYPE0 withAct_0;
    function void Called(TYPE0 ARG0);
      timesCnt += 1;

      withAct_0 = ARG0;
    endfunction


    //------
    // With
    //------

    bit checkWith = 0;
    TYPE0 withExp_0 = -1;
    function void With(TYPE0 ARG0);
      checkWith = 1;

      withExp_0 = ARG0;
    endfunction

    function bit check();
      check = super.check();

      check &= (checkWith) ? (withExp_0 == withAct_0)  : 1;

      return check;
    endfunction

    function clear();
      super.clear();

      checkWith = 0;
    endfunction
  endclass

  class __mocker2 #(type TYPE0 = int,
                    type TYPE1 = int) extends __mocker;

    function new(string name, ref __mocker __mockers[$]);
      super.new(name, __mockers);
    endfunction

    //--------
    // Called
    //--------

    TYPE0 withAct_0;
    TYPE1 withAct_1;
    function void Called(TYPE0 ARG0, TYPE1 ARG1);
      timesCnt += 1;

      withAct_0 = ARG0;
      withAct_1 = ARG1;
    endfunction


    //------
    // With
    //------

    bit checkWith = 0;
    TYPE0 withExp_0 = -1;
    TYPE1 withExp_1 = "";
    function void With(TYPE0 ARG0, TYPE1 ARG1);
      checkWith = 1;

      withExp_0 = ARG0;
      withExp_1 = ARG1;
    endfunction

    function bit check();
      check = super.check();

      check &= (checkWith) ? (withExp_0 == withAct_0)  : 1;
      check &= (checkWith) ? (withExp_1 == withAct_1)  : 1;

      return check;
    endfunction

    function clear();
      super.clear();

      checkWith = 0;
    endfunction
  endclass
endpackage