-- Main File
-- Info:    [here]
-- Authors: [here]
-- Date:    [here]

require "table_utils"
require "other_utils"
require "candidate"
require "Q_Algo"

--Mario RAM addresses
local PLAYER_XPAGE_ADDR     = 0x6D   --Player's page (screen) address
local PLAYER_PAGE_WIDTH     = 256    -- Width of pages
local PLAYER_XPOS_ADDR      = 0x86   --Player's position on the x-axis
local PLAYER_STATE_ADDR     = 0x000E --Player's state (dead/dying)
local PLAYER_VIEWPORT_ADDR  = 0x00B5 --Player's viewport status (falling)
local PLAYER_YPOS_ADDR      = 0x00CE --Player's y position address
local PLAYER_VPORT_HEIGHT   = 256    --raw height of viewport pages
local PLAYER_DOWN_HOLE      = 3    --VP+ypos val for falling into hole
local PLAYER_DYING_STATE    = 0x0B   --State value for dying player
local PLAYER_DEAD_STATE     = 0x06   --(CURRENTLY UNUSED!) State value for dead player
local PLAYER_FLOAT_STATE    = 0x001D --Used to check if player has won
local PLAYER_FLAGPOLE       = 0x03   --Player is sliding down flagpole.
local GAME_TIMER_ONES       = 0x07fA --Game Timer first digit
local GAME_TIMER_TENS       = 0x07f9 --Game Timer second digit
local GAME_TIMER_HUNDREDS   = 0x07f8 --Game Time third digit
local GAME_TIMER_MAX        = 400    --Max time allotted by game

-- init savestate & setup rng
math.randomseed(os.time());
ss = savestate.create();
savestate.save(ss);

local candidates = {};



while not contains_winner(candidates) do
	for curr=1,MAX_CANDIDATES do
		if candidates[curr].been_modified then
			savestate.load(ss);
			local player_x_val;
			local cnt = 0;
			local real_inp = 1;
			local max_cont = FRAME_MAX_PER_CONTROL * MAX_CONTROLS_PER_CAND

			for i = 1, max_cont do
				gui.text(0, TXT_INCR * 2, "Cand: "..curr)

				joypad.set(1, candidates[curr].inputs[real_inp]);

				--player_x_val = memory.readbyte(PLAYER_XPOS);
				
				score = tonumber(memory.readbyte(SCORE_FIRST_DIGIT)..
					memory.readbyte(SCORE_SECOND_DIGIT)..
					memory.readbyte(SCORE_THIRD_DIGIT)..
					memory.readbyte(SCORE_FOURTH_DIGIT)..
					memory.readbyte(SCORE_FIFTH_DIGIT)..
					memory.readbyte(SCORE_SIXTH_DIGIT)..
					memory.readbyte(SCORE_SEVENTH_DIGIT));
					
					

				gui.text(0, TXT_INCR * 3, "Fitness: "..score);
				
	        
				local d_state = memory.readbyte(PLAYER_CURRENT_LIVES);
				
				if d_state < 2 then
					gui.text(0, TXT_INCR * 4, "DYING");
					break;
				else
					gui.text(0, TXT_INCR * 4, "ALIVE");
				end

				if tonumber(score) >= 30001 then
					gui.text(0, TXT_INCR * 4, "WINNING");
					candidates[curr].has_won = true;
					break;
				end
	        
				tbl = joypad.get(1);
				gui.text(0, TXT_INCR * 5, "Input: "..ctrl_tbl_btis(tbl));
				gui.text(0, TXT_INCR * 6, "Curr Chromosome: "..real_inp);
				
				cnt = cnt + 1;
				if cnt == FRAME_MAX_PER_CONTROL then
					cnt = 0;
					real_inp = real_inp + 1;
				end
				
				candidates[curr].fitness = score;
				emu.frameadvance();
			end
		end
		candidates[curr].been_modified = false;
	end	
	
	
	--sort
	table.sort(candidates, function(a, b) return a.fitness > b.fitness end);
	print(candidates[1].fitness);
	
	--Add methods for Q-learning algo from Q-learning algo file here!!!
	
	
end

--]]
print("WINNER!");
