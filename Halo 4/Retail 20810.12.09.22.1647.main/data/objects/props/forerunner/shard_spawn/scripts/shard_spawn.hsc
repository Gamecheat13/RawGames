
global object selfCopy = none;

script startup instanced shard_spawn()
	print("Shard spawn startup.");
	selfCopy = this;
	InitializeShardSpawn(selfCopy);
end
