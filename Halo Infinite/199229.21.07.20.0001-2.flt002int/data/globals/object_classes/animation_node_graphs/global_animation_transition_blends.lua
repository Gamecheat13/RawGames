-- Copyright (c) Microsoft. All rights reserved.

function CreateDefaultTransitionBlendGraph()
     local blend = AnimGraph.CreateBlend();
     local sourcePose = AnimGraph.CreateTransitionData(AnimGraph.TransitionData.SourcePose);
     local destinationPose = AnimGraph.CreateTransitionData(AnimGraph.TransitionData.DestinationPose);
     local transitionTime = AnimGraph.CreateTransitionData(AnimGraph.TransitionData.TransitionTimeElapsedPercentage);

     NG.CreateLink(sourcePose.Out, blend.PoseA);
     NG.CreateLink(destinationPose.Out, blend.PoseB);
     NG.CreateLink(transitionTime.Out, blend.Alpha);

     return blend;
end