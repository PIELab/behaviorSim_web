!function(){function a(a,r){return a.partial("parameter_tweak",r,{param_name:"scale",option_type:"inflow-assertion",valu:2})}return dust.register("random_walk",a),a}();
;!function(){function a(a,e){return a.partial("parameter_tweak",e,{param_name:"low",option_type:"inflow-assertion",valu:1}).partial("parameter_tweak",e,{param_name:"high",option_type:"inflow-assertion",valu:10}).partial("parameter_tweak",e,{param_name:"frequency",option_type:"inflow-assertion",valu:7})}return dust.register("square",a),a}();
;!function(){function a(a,t){return a.partial("parameter_tweak",t,{param_name:"low",option_type:"inflow-assertion",valu:1}).partial("parameter_tweak",t,{param_name:"high",option_type:"inflow-assertion",valu:10}).partial("parameter_tweak",t,{param_name:"step_time",option_type:"inflow-assertion",valu:20})}return dust.register("step",a),a}();
;!function(){function e(e,r){return e.reference(r.get(["param_name"],!1),r,"h").write(' = <input type="text" id="').reference(r.get(["param_name"],!1),r,"h").write('-box" name="').reference(r.get(["param_name"],!1),r,"h").write('" class="model-option-').reference(r.get(["option_type"],!1),r,"h").write('" placeholder="???" value="').reference(r.get(["valu"],!1),r,"h").write('"/><input id="').reference(r.get(["param_name"],!1),r,"h").write('-slider" type="text" name="').reference(r.get(["param_name"],!1),r,"h").write('-slider" value=""/><br>')}return dust.register("parameter_tweak",e),e}();