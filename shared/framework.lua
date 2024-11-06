Framework = nil
if GetResourceState('es_extended') == 'started' then
    Framework = 'esx'
elseif GetResourceState('qb-core') == 'started' or GetResourceState('qbx_core') == 'started' then
    Framework = 'qb'
else
    return print('not framework')
end
