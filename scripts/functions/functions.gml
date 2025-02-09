#macro MAX_HSP 3
#macro MAX_VSP 3
#macro ACC 0.1
#macro DCC 0.1
#macro DASH_SPEED 10
#macro DASH_DURATION 5
#macro P_SPD 6
#macro COMBO_MAX 3
#macro COMBO_RESET_TIME 25
#macro ATTACK_COOLDOWN_DURATION 15

#macro MAX_ENERGY 80
#macro MAX_LIFE 5

///@desc imputs de movimento
//sistema de inputs para o movimento topdown
function __inputs() {
    return {
        r: function() {
            return keyboard_check(ord("D")); //direita
        },
        l: function() {
            return keyboard_check(ord("A")); //esquerda
        },
        u: function() {
            return keyboard_check(ord("W")); //cima
        },
        d: function() {
            return keyboard_check(ord("S")); //baixo
        },
        isHinput: function() {
            return self.r() || self.l(); //imput movimento lateral
        },
        isVinput: function() {
            return self.u() || self.d(); //imput movimento vertical
        },
        dash: function() {
            return keyboard_check_pressed(vk_space); //dash
        },
        parry: function() {
            return mouse_check_button_pressed(mb_right); //bloqueio
        },
        attack: function() {
            return mouse_check_button_pressed(mb_left); //ataque
        }
    };
}

//macro para os imputs
#macro INP __inputs()

///@desc função de movimento
//funções de moviemnto
function move_x(_hsp, _colision = oWall, _inst = id) {
    with (_inst) {
        var _dir_x = sign(_hsp);
        if (place_meeting(x + _dir_x, y, _colision)) hsp = 0;
        repeat(abs(_hsp)) {
            if (place_meeting(x + _dir_x, y, _colision)) return false;
            else x += _dir_x;
        }
    }
}

function move_y(_vsp, _colision = oWall, _inst = id) {
    with (_inst) {
        var _dir_y = sign(_vsp);
        if (place_meeting(x, y + _dir_y, _colision)) vsp = 0;
        repeat(abs(_vsp)) {
            if (place_meeting(x, y + _dir_y, _colision)) return false;
            else y += _dir_y;
        }
    }
}
