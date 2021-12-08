-- Copyright (c) Microsoft. All rights reserved.

function AnimUtils_PopulateSelection(source_list,context,selection_node)
	local anims = {};
	for i, v in ipairs(source_list)do 
		print(context..source_list[i][1],source_list[i][2], source_list[i][3],source_list[i][4]);
		anims[source_list[i][1]] = AnimGraph.CreateAnimation(context..source_list[i][1], source_list[i][2], source_list[i][3],source_list[i][4]);
		NG.CreateLink(anims[source_list[i][1]].Out, selection_node.Pose);
	end
	return anims;
end

function AnimGraph.HelperInputFloat(entry)
	local position = AnimGraph.CreateConstantFloat(entry);
	return position
end

--this is used in visualnode graph blendspaces to change the input of the sources to be a node
function AnimGraph.HelperInputVariableNode(entry)
            local funct = entry;
            return funct
        end