//By @Elioty

//função para adicionar um sub estado a estrutura
//os parametros são o nome do estado, a estrutura e a variável
function __add_sub_state(_name,_stru,_sub_state){
    
    //vaso a veriável não exista na estrutura
    if variable_struct_exists(_stru,_sub_state){
    
        //criar a variavel no objeto
        self[$ string(_name)+"_"+_sub_state] = _stru[$ _sub_state]
    }
}

//execução das informações guardadas na variável setada anteriormente
function __sub_state_execute(_state){
    //caso a variável seja diferente de indefinido, executar as funções guardadas nela
    if !is_undefined(self[$ current_state+"_"+_state]) script_execute(self[$ current_state+"_"+_state])
}

///@desc inicia as variaves para a maquina de estados
function lsm_init(){
    //criando variáveis que guardarão arrays sobre estado, estado atual, entrada em estados e habilitar o estado livre
    self[$ "states"] = []
    self[$ "current_state"] = noone
    self[$ "enter_state"] = false
    self[$ "free_state_enable"] = false
}

///@desc atualiza o estado a cada frame
function lsm_update(){
    //caso free_state_enable seja verdadeiro
    if free_state_enable{
        //caso as variáveis existam, executar as funções guardadas nelas
        if !is_undefined(self[$ "free_state_step_begin"]) script_execute(self[$ "free_state_step_begin"])
        if !is_undefined(self[$ "free_state_step"]) script_execute(self[$ "free_state_step"])
        if !is_undefined(self[$ "free_state_step_end"]) script_execute(self[$ "free_state_step_end"])
    }
    
    //caso enter_state seja falsa, rodar uma vez o enter do estado, e em seguida tornar a variável verdadeira
    if enter_state == false{
        __sub_state_execute("enter")
        enter_state = true
    }
    
    //caso current_state seja diferente de noone, ou igual a uma das variáveis, ele as executará a todo frame em sequência
    if current_state != noone{
        __sub_state_execute("begin_step")
        __sub_state_execute("step")
        __sub_state_execute("end_step")
    }
    
}

///@desc desenha o draw de cada estado
function lsm_draw(){
    //caso a variável free_state_draw não seja indefinida, executar o codigo de esenho definido
    if !is_undefined(self[$ "free_state_draw"]) script_execute(self[$ "free_state_draw"])
    __sub_state_execute("draw")
}

///@desc desenha o draw gui de cada estado
function lsm_draw_gui(){
        //caso a variável free_state_draw_gui não seja indefinida, executar o codigo de esenho definido
    if !is_undefined(self[$ "free_state_draw_gui"]) script_execute(self[$  "free_state_draw_gui"])
    __sub_state_execute("draw_gui")
}



///@desc adiciona um novo estado
/// @arg {String} _name o nome do estado
/// @arg {Struct} _stru a estrutura com os sub estado

//a função guarda o nome do estado a ser adicionado e a estrutura na qual ele será armazenado, o array _stru
function lsm_add(_name, _stru = {}){
    //adiciona o novo valor ao array de estados
    array_push(states,_name)
    
    //adição do "evento" de etapa
    __add_sub_state(_name,_stru,"step")
    
    //adição do "evento "criar
    __add_sub_state(_name,_stru,"enter")
    
    //adição do "evento" de etapa inicial   
    __add_sub_state(_name,_stru,"begin_step")
    
    //adição do "evento" de etapa final
    __add_sub_state(_name,_stru,"end_step")
    
    //adição do "evento" de desenho
    __add_sub_state(_name,_stru,"draw")
    
    //adição do "evento" de desenho em tela
    __add_sub_state(_name,_stru,"draw_gui")
    
    //adição do "evento" de saida de estado
    __add_sub_state(_name,_stru,"leave")
}

///@desc muda de estado
///@arg {String} _name nome do estado de destino
function lsm_change(_name){
    //executa a mudança dos estados ao ser chamado
    if !is_undefined(self[$ current_state+"_leave"]) script_execute(self[$ current_state+"_leave"])
        
    //muda o estado
    current_state = _name
    
    //roda uma vez o enter
    enter_state = false
}

///@desc adiciona um estado que vai rodar todo tempo

//esse estado roda de forma independente ao estado atual do objeto
function lsm_add_free_state(_stru={ }){
    var _name = "free_state"
    free_state_enable = true
    
    __add_sub_state(_name,_stru,"step")
        
    __add_sub_state(_name,_stru,"begin_step")
    
    __add_sub_state(_name,_stru,"end_step")
    
    __add_sub_state(_name,_stru,"draw")
    
    __add_sub_state(_name,_stru,"draw_gui")
    
    __add_sub_state(_name,_stru,"leave")
}

