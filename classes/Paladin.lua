function mb_Paladin_OnLoad()

end

function mb_Paladin_OnUpdate()
	local mbCom = mb_getIncomingCommunication()
	if mbCom ~= nil then
		mb_print("From: " .. mbCom.from .. ". Msg: " .. mbCom.message)
	end
end