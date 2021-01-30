function shader_flashing_set(frequency_factor, half_amount) {
    shader_set(shFlash);
    var frame_ctr = shader_get_uniform(shFlash, "params");
    shader_set_uniform_f(
        frame_ctr, 
        frequency_factor,
        half_amount
    );
}

