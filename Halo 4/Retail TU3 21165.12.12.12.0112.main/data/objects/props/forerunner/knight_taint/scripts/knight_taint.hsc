
global object selfCopy = none;

script startup instanced knight_taint()
	print("Knight taint startup.");
	selfCopy = this;
	InitializeKnightTaint(selfCopy);
end
