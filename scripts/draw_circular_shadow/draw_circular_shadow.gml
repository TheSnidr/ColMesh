function draw_circular_shadow(alpha)
{
	//Function for creating a cylinder as a pr_trianglelist vertex buffer
	static ___create_cylinder = function(steps)
	{
		vertex_format_begin();
		vertex_format_add_position_3d();
		vertex_format_add_normal();
		var format = vertex_format_end();
		var vbuff = vertex_create_buffer();
		vertex_begin(vbuff, format);
		for (var xx = 0; xx < steps; xx ++)
		{
			var xa1 = xx / steps * 2 * pi;
			var xa2 = (xx+1) / steps * 2 * pi;
			var xc1 = cos(xa1);
			var xs1 = sin(xa1);
			var xc2 = cos(xa2);
			var xs2 = sin(xa2);
		
			vertex_position_3d(vbuff, xc1, xs1, 0);
			vertex_normal(vbuff, xc1, xs1, 0);
			vertex_position_3d(vbuff, xc1, xs1, 1);
			vertex_normal(vbuff, xc1, xs1, 0);
			vertex_position_3d(vbuff, xc2, xs2, 0);
			vertex_normal(vbuff, xc2, xs2, 0);
		
			vertex_position_3d(vbuff, xc2, xs2, 0);
			vertex_normal(vbuff, xc2, xs2, 0);
			vertex_position_3d(vbuff, xc1, xs1, 1);
			vertex_normal(vbuff, xc1, xs1, 0);
			vertex_position_3d(vbuff, xc2, xs2, 1);
			vertex_normal(vbuff, xc2, xs2, 0);
		
			//Bottom lid
			vertex_position_3d(vbuff, 1, 0, 0);
			vertex_normal(vbuff, 0, 0, -1);
			vertex_position_3d(vbuff, xc1, xs1, 0);
			vertex_normal(vbuff, 0, 0, -1);
			vertex_position_3d(vbuff, xc2, xs2, 0);
			vertex_normal(vbuff, 0, 0, -1);
		
			//Top lid
			vertex_position_3d(vbuff, 1, 0, 1);
			vertex_normal(vbuff, 0, 0, 1);
			vertex_position_3d(vbuff, xc2, xs2, 1);
			vertex_normal(vbuff, 0, 0, 1);
			vertex_position_3d(vbuff, xc1, xs1, 1);
			vertex_normal(vbuff, 0, 0, 1);
		}
		vertex_end(vbuff);
		vertex_freeze(vbuff);
		return vbuff;
	}
	//Draw inverted cylinder to the hidden destination alpha channel
	static cylinder = ___create_cylinder(22);
	var zwrite = gpu_get_zwriteenable();
	var blendmode = gpu_get_blendmode();
	var cullmode = gpu_get_cullmode();
	
	gpu_set_zwriteenable(false);
	gpu_set_blendmode_ext_sepalpha(bm_zero, bm_one, bm_one, bm_zero);
	gpu_set_cullmode(cull_clockwise);
	
	//Draw inverted cylinder 
	shader_set(sh_shadow);
	shader_set_uniform_f(shader_get_uniform(sh_shadow, "u_color"), 0, 0, 0, 1 - alpha);
	vertex_submit(cylinder, pr_trianglelist, -1);

	//Draw cylinder with a special blend mode that filters away the parts of the cylinder that are drawn above the inverted cylinder, resulting in a projected circle
	gpu_set_cullmode(cull_counterclockwise);
	gpu_set_blendmode_ext_sepalpha(bm_dest_color, bm_inv_dest_alpha, bm_one, bm_zero);
	shader_set_uniform_f(shader_get_uniform(sh_shadow, "u_color"), 1 - alpha, 1 - alpha, 1 - alpha, 1);
	vertex_submit(cylinder, pr_trianglelist, -1);
	
	//Reset GPU settings
	shader_reset();
	gpu_set_zwriteenable(zwrite);
	gpu_set_blendmode(blendmode);
	gpu_set_cullmode(cullmode);
}