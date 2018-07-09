`define SVMOCK_MOCKER_CLASS2(NAME,RETURNS,TYPE0,ARG0,MOD0,TYPE1,ARG1,MOD1,MODIFIER=) \
class __``NAME``MODIFIER``__mocker  extends __mocker; \
`PARENT parent; \
function new(string name, ref __mocker __mockers[$], input `PARENT _parent, input __``NAME``MODIFIER``__mocker associate = null); \
  super.new(name, __mockers); \
  parent = _parent; \
  if (associate != null) associate.possibilities[name] = this; \
endfunction \
virtual function RETURNS NAME(TYPE0 ARG0 MOD0,TYPE1 ARG1 MOD1); \
endfunction \
TYPE0 withAct_0 MOD0, withExp_0 MOD0; \
TYPE1 withAct_1 MOD1, withExp_1 MOD1; \
function void called(TYPE0 ARG0 MOD0,TYPE1 ARG1 MOD1); \
  timesCnt += 1; \
  withAct_0 = ARG0; \
  withAct_1 = ARG1; \
endfunction \
__``NAME``MODIFIER``__mocker possibilities [string]; \
__``NAME``MODIFIER``__mocker instead; \
function void will_by_default(string i); \
  instead = possibilities[i]; \
endfunction \
function void with_args(TYPE0 ARG0 MOD0,TYPE1 ARG1 MOD1); \
  checkWith = 1; \
  withExp_0 = ARG0; \
  withExp_1 = ARG1; \
endfunction \
function bit check(); \
  check = super.check(); \
  check &= (checkWith) ? (withExp_0 == withAct_0)  : 1; \
  check &= (checkWith) ? (withExp_1 == withAct_1)  : 1; \
  return check; \
endfunction \
function void clear(); \
  super.clear(); \
  instead = null; \
endfunction \
endclass

`define SVMOCK_FUNCTION_MOCKER_CLASS2(NAME,RETURNS,TYPE0,ARG0,MOD0,TYPE1,ARG1,MOD1) \
`SVMOCK_MOCKER_CLASS2(NAME,RETURNS,TYPE0,ARG0,MOD0,TYPE1,ARG1,MOD1,_base) \
class __``NAME``__mocker  extends __``NAME``_base__mocker; \
function new(string name, ref __mocker __mockers[$], input `PARENT _parent, input __``NAME``__mocker associate = null); \
  super.new(name, __mockers, _parent, associate); \
endfunction \
RETURNS returnsVal; \
function void returns(RETURNS r); \
  overrideReturn = 1; \
  returnsVal = r; \
endfunction \
endclass
