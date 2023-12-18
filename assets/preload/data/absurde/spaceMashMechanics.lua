function opponentNoteHit(membersIndex, noteData, noteType, isSustainNote)
    if not botPlay then
        if isSustainNote then
            setProperty('spaceMashImage.alpha', getProperty('spaceMashImage.alpha') + 0.005)
        else
            setProperty('spaceMashImage.alpha', getProperty('spaceMashImage.alpha') + 0.01)
        end
    end
end

function onUpdate(elapsed)
    if getProperty('spaceMashImage.alpha') >= 1 then
        setHealth(0)
    end
    if keyJustPressed('space') then
        setProperty('spaceMashImage.alpha', getProperty('spaceMashImage.alpha') - 0.05)
    end
end