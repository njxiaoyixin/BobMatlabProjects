function ClearAllTimers()
allTimer = timerfindall;
if ~isempty(allTimer)
    stop(allTimer);
    delete(allTimer)
end
end