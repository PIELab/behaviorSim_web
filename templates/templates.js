!function(){function a(a,r){return a.partial("parameter_tweak",r,{param_name:"scale",option_type:"inflow-assertion",valu:2})}return dust.register("random_walk",a),a}();
;!function(){function a(a,t){return a.partial("parameter_tweak",t,{param_name:"low",option_type:"inflow-assertion",valu:1}).partial("parameter_tweak",t,{param_name:"high",option_type:"inflow-assertion",valu:10}).partial("parameter_tweak",t,{param_name:"dt",option_type:"inflow-assertion",valu:7})}return dust.register("square",a),a}();
;!function(){function a(a,t){return a.partial("parameter_tweak",t,{param_name:"low",option_type:"inflow-assertion",valu:1}).partial("parameter_tweak",t,{param_name:"high",option_type:"inflow-assertion",valu:10}).partial("parameter_tweak",t,{param_name:"step_time",option_type:"inflow-assertion",valu:20})}return dust.register("step",a),a}();
;!function(){function e(e){return e.write('<input type="file" accept="text/csv"><br>File should be comma-separated with time values in the first column and variable value in the second. Example:<br>0,1<br>1,1<br>2,2<br>3,3<br>4,5<br>')}return dust.register("upload",e),e}();
;!function(){function e(e,r){return e.reference(r.get(["param_name"],!1),r,"h").write(' = <input type="text" id="').reference(r.get(["param_name"],!1),r,"h").write('-box" name="').reference(r.get(["param_name"],!1),r,"h").write('" class="model-option-').reference(r.get(["option_type"],!1),r,"h").write('" placeholder="???" value="').reference(r.get(["valu"],!1),r,"h").write('"/><input id="').reference(r.get(["param_name"],!1),r,"h").write('-slider" type="text" name="').reference(r.get(["param_name"],!1),r,"h").write('-slider" value=""/><br>')}return dust.register("parameter_tweak",e),e}();
;!function(){function e(e,t){return e.write('<input type="text" name="entry.209092399" id="entry_209092399" value="').reference(t.get(["PID"],!1),t,"h").write('"><input type="text" name="entry.1211663995" id="entry_1211663995" value="').reference(t.get(["DSL"],!1),t,"h",["s"]).write('"></textarea><input type="text" name="entry.1334267476" id="entry_1334267476" value="').reference(t.get(["Model"],!1),t,"h",["js"]).write('"></textarea><input type="text" name="entry.1143926957" id="entry_1143926957" value="').reference(t.get(["UserAgent"],!1),t,"h",["s"]).write('">')}return dust.register("model_builder_usability",e),e}();
;!function(){function t(t){return t.write('<input type="text" name="entry.209092399" value="" class="ss-q-short" id="entry_209092399" dir="auto" aria-label="PID  " title="">')}return dust.register("sample_form",t),t}();