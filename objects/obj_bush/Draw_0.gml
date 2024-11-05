/// @description Draw grass

// Verifica se a surface já existe, caso contrário, cria uma nova
if (!surface_exists(surf_bush)) {
    surf_bush = surface_create(room_width, room_height);
}

// Define a surface como alvo de desenho
surface_set_target(surf_bush);

// Limpa a surface para garantir que não há resíduos visuais
draw_clear_alpha(c_white, 0);

// Ativa o shader e define o valor do tempo no shader
shader_set(sh_shd_bush);
shader_set_uniform_f(uniTime, current_time / 1000);

// Desenha o conteúdo desejado na surface usando o shader
draw_self();

// Desativa o shader
shader_reset();

// Remove o alvo da surface para voltar ao desenho normal
surface_reset_target();

// Agora, desenha a surface com a grama na tela
draw_surface(surf_bush, 0, 0);
