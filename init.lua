welcome_screen = {}

local input = io.open(minetest.get_modpath("welcome_screen") .. "/rules.lua", "r")

if input then
	dofile(minetest.get_modpath("welcome_screen") .. "/rules.lua")
	input:close()
	input = nil
else
    welcome_screen.rules = "Please set up your rules.conf file."
    welcome_screen.warning = "Please set up your rules.conf file."
    welcome_screen.grant_privs = {"interact"}
end

welcome_screen.fix_text = function(text)
        text = minetest.formspec_escape(text)
        text = string.gsub(text, "\n", ",")
        return text
end

welcome_screen.formspec_initial = "size[12,10]" .. default.gui_bg .. default.gui_bg_img .. 
                                "tablecolumns[text]" ..
                                "tableoptions[background=#000000A0;highlight=#000000A0;border=false]" ..
                                "table[1,0.2;9.85,9;cunt;" .. welcome_screen.fix_text(welcome_screen.rules) .. "]" ..
                                "button[3.75,9.65;2,0.3;decline;Decline]" .. 
                                "button_exit[6.25,9.65;2,0.3;accept;Accept]"

welcome_screen.formspec_agreed = "size[12,10]" .. default.gui_bg .. default.gui_bg_img .. 
                                "tablecolumns[text]" ..
                                "tableoptions[background=#000000A0;highlight=#000000A0;border=false]" ..
                                "table[1,0.2;9.85,9;cunt;" .. welcome_screen.fix_text(welcome_screen.rules) .. "]" ..
                                "button_exit[5,9.65;2,0.3;close;Close]"

welcome_screen.formspec_warning = "size[6,4]" .. default.gui_bg .. default.gui_bg_img .. 
                                "tablecolumns[text]" ..
                                "tableoptions[background=#000000A0;highlight=#000000A0;border=false]" ..
                                "table[0.25,0.1;5.35,3.15;cunt;" .. welcome_screen.fix_text(welcome_screen.warning) .. "]" ..
                                "button_exit[2,3.7;2,0.3;accept;Accept]"

minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
    local privs = minetest.get_player_privs(name)
    for _,priv in pairs(welcome_screen.grant_privs) do
        if not privs[priv] then
            minetest.show_formspec(name, "welcome_screen_initial", welcome_screen.formspec_initial)
            break
        end
    end
end)

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= "welcome_screen_initial" then return end
	local name = player:get_player_name()
	if fields.accept then
        local privs = minetest.get_player_privs(name)
        for _, priv in pairs(welcome_screen.grant_privs) do
            privs[priv] = true
            minetest.set_player_privs(name, privs)
        end
        minetest.log("action", "[Welcome Screen]: " .. name .. " agreed to the rules")
    elseif fields.quit or fields.decline then
        minetest.show_formspec(name, "welcome_screen_warn", welcome_screen.formspec_warning)
	end
end)

welcome_screen.show_rules = function(name)
    local privs = ""
    local user = ""
    if type(name) ~= "string" and name:is_player() then
        user = name:get_player_name()
        privs = minetest.get_player_privs(user)
    else
        privs = minetest.get_player_privs(name)
        user = name
    end
    for _,priv in pairs(welcome_screen.grant_privs) do
        if not privs[priv] then
            minetest.show_formspec(user, "welcome_screen_initial", welcome_screen.formspec_initial)
            break
        else
            minetest.show_formspec(user, "welcome_screen_agreed", welcome_screen.formspec_agreed)
        end
    end
end

minetest.register_chatcommand("rules",{
	params = "",
	description = "Shows the server rules",
	privs = {shout = true},
	func = welcome_screen.show_rules
})

if minetest.get_modpath("sfinv_buttons") then
    sfinv_buttons.register_button("welcome_screen_button", 
    {
    title = "Server Rules",
    action = welcome_screen.show_rules,
    tooltip = "Show server rules",
    image = "rules_thumbnail.png",
    })
end
