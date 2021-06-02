class Main extends Actor;

var int GameID;
var DodgeLogger DodgeLogger;

function PreBeginPlay()
{
	DodgeLogger = Spawn(class'DodgeLogger');
}

function Tick(float DeltaTime)
{
	SpawnDodgeRecorderIfNewPlayerJoined();

	if (Level.Game.bGameEnded)
	{
		DodgeLogger.CloseLogFile();
	}
}

function SpawnDodgeRecorderIfNewPlayerJoined()
{
	local Pawn Pawn;
	local DodgeRecorder DodgeRecorder;
	if (Level.Game.CurrentID > GameID)
	{
		for (Pawn = Level.PawnList; Pawn != None; Pawn = Pawn.NextPawn)
			if (Pawn.PlayerReplicationInfo.PlayerID == GameID) break;
		GameID++;

		if (PlayerPawn(Pawn) != None && Pawn.bIsPlayer && (!Pawn.PlayerReplicationInfo.bIsSpectator || Pawn.PlayerReplicationInfo.bWaitingPlayer))
		{
			DodgeRecorder = Spawn(class'DodgeRecorder', PlayerPawn(Pawn));
			DodgeRecorder.DodgeLogger = DodgeLogger;
		}
	}
}

defaultproperties
{
    bHidden=True
}
