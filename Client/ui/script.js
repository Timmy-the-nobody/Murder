let dRoot = document.querySelector( ":root" )
let dTarget = document.getElementById( "target" )

Events.Subscribe( "SetElementDisplay", function( sElement, sDisplay ) {
    document.getElementById( sElement ).style.display = sDisplay
} )

Events.Subscribe( "SetElementInnerHTML", function( sElement, sValue ) {
    document.getElementById( sElement ).innerHTML = sValue
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