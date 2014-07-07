@echo off
Setlocal EnableDelayedExpansion
set "defaultquality=medium"
set "streamurl="
set "quality="


::Code - do not modify
:START
cls
echo What service do you want to use?
echo ( TwitchTV, Custom [More coming] )
set /p "service="
if /i "%service%" == "" (
	cls
	COLOR 0C
	echo ERR: The service you specified could not be found.
	sleep 3
	COLOR 07
	cls
	GOTO START
) else (
	if /i "%service%" == "twitchtv" (
		GOTO TWITCH
	) else (
		if /i "%service%" == "custom" (
			GOTO CUSTOM
		) else (
			cls
			COLOR 0C
			echo ERR: The service you specified could not be found.
			sleep 3
			COLOR 07
			cls
			GOTO START
		)
		GOTO START
	)
)


:CUSTOM
cls
echo What's the complete URL to the livestreaming media?
echo ( Exmaple: http://example.com/livestream )
set /p "streamurl="
if "%streamurl%" == "" (
	cls
	COLOR 0C
	echo ERR: No streamname was chosen, try again.
	sleep 3
	COLOR 07
	GOTO custom
) else (
	GOTO QUALITY
)
:TWITCH
cls
echo What's the name of the channel?
set /p "streamname="
if "%streamname%" == "" (
	cls
	COLOR 0C
	echo ERR: No streamname was chosen, try again.
	sleep 3
	COLOR 07
	GOTO TWITCH
) else (
	set "streamurl=http://twitch.tv/"
	GOTO QUALITY
)
:QUALITY
cls
echo What quality does the stream should have?
echo ( mobile (worst), low, medium, high, source (best) )
echo (Default is %defaultquality%)

set /p "quality="
if "%quality%" == "" (
	set quality=%defaultquality%
	GOTO FORWARD
) else (
	GOTO FORWARD
)

:FORWARD
cls
livestreamer %streamurl%%streamname% %quality%
