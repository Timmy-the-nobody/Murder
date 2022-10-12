let dRoot = document.querySelector( ":root" )
let dTarget = document.getElementById( "target" )

Events.Subscribe( "SetElementDisplay", function( sElement, sDisplay ) {
    document.getElementById( sElement ).style.display = sDisplay
} )

Events.Subscribe( "SetElementInnerHTML", function( sElement, sValue, sStyle ) {
    let dElement = document.getElementById( sElement )
    dElement.innerHTML = sValue

    if ( sStyle ) {
        dElement.style.cssText = sStyle
    }
} )

Events.Subscribe( "SetProperty", function( sProperty, sValue ) {
    dRoot.style.setProperty( "--" + sProperty, sValue )
} ) 

Events.Subscribe( "ShowTarget", function( bVisible, sName, sColor, iX, iY ) {
    if ( !bVisible ) {
        dTarget.style.display = "none"
        return
    }

    dTarget.innerHTML = sName
    dTarget.style.color = sColor
    dTarget.style.left = iX + "px"
    dTarget.style.top = iY + "px"
    dTarget.style.display = "block"
} )

// showStartScreen
let dStartScreen = document.getElementById( "start-screen" )
let dStartScreenTitle = document.getElementById( "start-screen-title" )
let dStartScreenText = document.getElementById( "start-screen-text" )

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

Events.Subscribe( "ShowStartScreen", showStartScreen )

// makeBlind
let dTKBlindScreen = document.getElementById( "tk-blind-screen" )

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

Events.Subscribe( "MakeBlind", makeBlind )