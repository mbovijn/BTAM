class DodgeLogger extends Actor;

var Logger Logger;

function PreBeginPlay()
{
    InitialiseLogFile();
	LogHeader();
	SetTimer(5.0, True);
}

function Timer()
{
	if (Logger != None)
	{
		Logger.FileFlush();
	}
}

function InitialiseLogFile()
{
	Logger = Spawn(class'Logger');
	Logger.StatLogFile = "../Logs/BTAM."$Logger.GetAbsoluteTime()$".tmp.csv";
	Logger.StatLogFinal = "../Logs/BTAM."$Logger.GetAbsoluteTime()$".csv";
	Logger.OpenLog();
}

function CloseLogFile()
{
	if (Logger != None)
	{
		Logger.StopLog();
		Logger = None;
	}
}

function LogHeader()
{
	Logger.FileLog("Timestamp,PlayerName,IP,DodgeDir,DoubleTapTimeInSeconds,TimeSincePreviousDodgeInSeconds");
}

function LogDodgeEvent(PlayerPawn PlayerPawn, EDodgeDir DodgeDir, float DoubleTapTimeInSeconds, float TimeSinceLastDodgeInSeconds)
{
	Logger.FileLog(
		GetCurrentTimeInISO8601()$","$
		Repl(PlayerPawn.PlayerReplicationInfo.PlayerName, ",", "")$","$
		GetPlayerIP(PlayerPawn)$","$
		GetEnum(Enum'EDodgeDir', DodgeDir)$","$
		DoubleTapTimeInSeconds$","$
		TimeSinceLastDodgeInSeconds
	);
}

function string GetCurrentTimeInISO8601()
{
	local string AbsoluteTime;

	AbsoluteTime = string(Level.Year);

	if (Level.Month < 10)
		AbsoluteTime = AbsoluteTime$"-0"$Level.Month;
	else
		AbsoluteTime = AbsoluteTime$"-"$Level.Month;

	if (Level.Day < 10)
		AbsoluteTime = AbsoluteTime$"-0"$Level.Day;
	else
		AbsoluteTime = AbsoluteTime$"-"$Level.Day;
	
	if (Level.Hour < 10)
		AbsoluteTime = AbsoluteTime$"T0"$Level.Hour;
	else
		AbsoluteTime = AbsoluteTime$"T"$Level.Hour;

	if (Level.Minute < 10)
		AbsoluteTime = AbsoluteTime$":0"$Level.Minute;
	else
		AbsoluteTime = AbsoluteTime$":"$Level.Minute;

	if (Level.Second < 10)
		AbsoluteTime = AbsoluteTime$":0"$Level.Second;
	else
		AbsoluteTime = AbsoluteTime$":"$Level.Second;

	if (Level.Millisecond < 10)
		AbsoluteTime = AbsoluteTime$".00"$Level.Millisecond;
	else if (Level.Millisecond < 100)
		AbsoluteTime = AbsoluteTime$".0"$Level.Millisecond;
	else
		AbsoluteTime = AbsoluteTime$"."$Level.Millisecond;

	return AbsoluteTime;
}

function string GetPlayerIP(PlayerPawn PlayerPawn)
{
	local string Address;
	Address = PlayerPawn.GetPlayerNetworkAddress();
	return Left(Address, Instr(Address, ":"));
}

defaultproperties
{
    bHidden=True
}
