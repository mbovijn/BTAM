class DodgeRecorder extends Actor;

var DodgeLogger DodgeLogger;

var EDodgeDir PreviousDodgeDir;
var float TimeSinceLastDodgeInSeconds;

replication
{
	reliable if (Role < ROLE_Authority)
		ReplicateDodgeEvent;
}

function ReplicateDodgeEvent(EDodgeDir DodgeDir, float DoubleTapTimeInSeconds, float TimeSinceLastDodgeInSeconds)
{
	if (DodgeLogger != None)
	{
		DodgeLogger.LogDodgeEvent(PlayerPawn(Owner), DodgeDir, DoubleTapTimeInSeconds, TimeSinceLastDodgeInSeconds);
	}
}

simulated function Tick(float DeltaTime)
{
	local PlayerPawn PlayerPawn; 

	if (Role < ROLE_Authority)
	{
		PlayerPawn = PlayerPawn(Owner);

		if (IsStartOfDodge(PlayerPawn))
		{
			ReplicateDodgeEvent(PreviousDodgeDir, PlayerPawn.DodgeClickTime - PlayerPawn.DodgeClickTimer, TimeSinceLastDodgeInSeconds);
		}
		else if (IsEndOfDodge(PlayerPawn))
		{
			TimeSinceLastDodgeInSeconds = 0;
		}

		TimeSinceLastDodgeInSeconds += DeltaTime;
		PreviousDodgeDir = PlayerPawn.DodgeDir;
	}
}

simulated function bool IsStartOfDodge(PlayerPawn PlayerPawn)
{
	return (PreviousDodgeDir == Dodge_Forward || PreviousDodgeDir == Dodge_Back || PreviousDodgeDir == Dodge_Left || PreviousDodgeDir == Dodge_Right)
				&& PlayerPawn.DodgeDir == Dodge_Active;
}

simulated function bool IsEndOfDodge(PlayerPawn PlayerPawn)
{
	return PreviousDodgeDir == Dodge_Active && PlayerPawn.DodgeDir == Dodge_Done;
}

defaultproperties
{
    bHidden=True
    NetPriority=4.00
	RemoteRole=ROLE_SimulatedProxy
	bAlwaysRelevant=True
}
