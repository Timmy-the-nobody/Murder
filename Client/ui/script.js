let dRoot = document.querySelector( ":root" )
let dTarget = document.getElementById( "target" )
let dStartScreen = document.getElementById( "start-screen" )
let dStartScreenTitle = document.getElementById( "start-screen-title" )
let dStartScreenText = document.getElementById( "start-screen-text" )
let dTKBlindScreen = document.getElementById( "tk-blind-screen" )
let dNotifContainer = document.getElementById( "notification-container" )

// setElementDisplay
let setElementDisplay = function( sElement, sDisplay ) {
    document.getElementById( sElement ).style.display = sDisplay
}

// setElementInnerText
let setElementInnerText = function( sElement, sValue, sStyle ) {
    let dElement = document.getElementById( sElement )
    dElement.innerText = sValue

    if ( sStyle ) {
        dElement.style.cssText = sStyle
    }
}

// setElementProperty
let setElementProperty = function( sElement, sProperty, sValue ) {
    document.getElementById( sElement ).style.setProperty( "--" + sProperty, sValue )
}

// setProperty
let setProperty = function( sProperty, sValue ) {
    dRoot.style.setProperty( "--" + sProperty, sValue )
}

// showTarget
let showTarget = function( bVisible, sName, sColor, iX, iY ) {
    if ( !bVisible ) {
        dTarget.style.display = "none"
        return
    }

    dTarget.innerHTML = sName
    dTarget.style.color = sColor
    dTarget.style.left = iX + "px"
    dTarget.style.top = iY + "px"
    dTarget.style.display = "block"
}

// showStartScreen
let showStartScreen = function( sTitle, sText, iTime ) {
    dStartScreenTitle.innerHTML = sTitle
    dStartScreenText.innerHTML = sText

    dStartScreen.style.display = "block"
    dStartScreen.style.opacity = 1

    setTimeout( function() {
        dStartScreen.animate( [
            { opacity: 1 },
            { opacity: 0 }
        ], {
            duration: 3000,
            easing: "ease-in-out"
        } ).onfinish = function() {
            dStartScreen.style.display = "none"
        }
    }, iTime )
}

// makeBlind
let makeBlind = function( iTime, iFadeOutTime ) {
    dTKBlindScreen.style.opacity = 0
    dTKBlindScreen.style.display = "block"

    let tAnim = dTKBlindScreen.animate( [
        { opacity: 0 },
        { opacity: 1 }
    ], {
        duration: 500,
        easing: "ease-in-out",
        fill: "forwards"
    } )

    tAnim.onfinish = function() {
        setTimeout( function() {
            dTKBlindScreen.animate( [
                { opacity: 1 },
                { opacity: 0 }
            ], {
                duration: ( iFadeOutTime || 500 ),
                easing: "ease-in-out"
            } ).onfinish = function() {
                dTKBlindScreen.style.display = "none"
            }
        }, ( iTime || 3000 ) )
    }
}

// notify
let notify = function( sText, iTime, sColor, sIcon ) {
    let dNotif = document.createElement( "div" )
    dNotif.className = "r-container notification"
    dNotif.style.setProperty( "--container-color", sColor || "red" )

    let dIconHolder = document.createElement( "div" )
    dIconHolder.className = "notification-icon-holder"
    dNotif.appendChild( dIconHolder )

    let dIcon = document.createElement( "div" )
    dIcon.className = "notification-icon fa fa-" + ( sIcon || "circle-dot" )
    dIconHolder.appendChild( dIcon )

    let dText = document.createElement( "div" )
    dText.className = "hud-text"
    dText.innerText = sText
    dNotif.appendChild( dText )

    dNotifContainer.appendChild( dNotif )

    dNotif.style.marginRight = "calc(-150%)"
    dNotif.animate( [
        { marginRight: "-100%", opacity: 0 },
        { marginRight: "0%", opacity: 1 }
    ], {
        duration: 500,
        fill: "forwards"
    } )

    setTimeout( function() {
        dNotif.animate( [
            { opacity: 1 },
            { opacity: 0 }
        ], {
            duration: 500
        } ).onfinish = function() {
            dNotif.remove()
        }
    }, ( iTime || 3000 ) )
}

// SCOREBOARD
let dScoreboardList = document.getElementById( "scoreboard-list-container" )

let addScoreboardRow = function( sSteamID, sName ) {
    let dLine = document.createElement( "div" )
    dLine.className = "scoreboard-line"
    dLine.steamID = sSteamID
    dScoreboardList.appendChild( dLine )

    let dName = document.createElement( "div" )
    dName.className = "scoreboard-line-content"
    dName.style.width = "200%"
    dName.innerText = sName
    dLine.appendChild( dName )

    let dScore = document.createElement( "div" )
    dScore.className = "scoreboard-line-content"
    dScore.innerText = "0"
    dScore.style.textAlign = "center"
    dLine.appendChild( dScore )

    let dPing = document.createElement( "div" )
    dPing.className = "scoreboard-line-content"
    dPing.innerText = "0 ms"
    dPing.style.textAlign = "center"
    dLine.appendChild( dPing )
}

// removeScoreboardRow
let removeScoreboardRow = function( sSteamID ) {
    for ( let k in dScoreboardList.children ) {
        let dLine = dScoreboardList.children[ k ]
        if ( dLine.steamID == sSteamID ) {
            dLine.remove()
            return
        }
    }
}

// updateScoreboardRow
let updateScoreboardRow = function( sSteamID, iScore, iPing ) {
    for ( let k in dScoreboardList.children ) {
        let dLine = dScoreboardList.children[ k ]
        if ( dLine.steamID == sSteamID ) {
            dLine.children[ 1 ].innerText = iScore
            dLine.children[ 2 ].innerText = iPing + " ms"
            return
        }
    }
}

// Nanos events
if ( typeof( Events ) != "undefined" ) {
    Events.Subscribe( "SetElementDisplay", setElementDisplay )
    Events.Subscribe( "SetElementInnerText", setElementInnerText )
    Events.Subscribe( "SetElementProperty", setElementProperty )
    Events.Subscribe( "SetProperty", setProperty ) 
    Events.Subscribe( "ShowTarget", showTarget )
    Events.Subscribe( "ShowStartScreen", showStartScreen )
    Events.Subscribe( "MakeBlind", makeBlind )
    Events.Subscribe( "Notify", notify )

    Events.Subscribe( "AddScoreboardRow", addScoreboardRow )
    Events.Subscribe( "RemoveScoreboardRow", removeScoreboardRow )
    Events.Subscribe( "UpdateScoreboardRow", updateScoreboardRow )
}