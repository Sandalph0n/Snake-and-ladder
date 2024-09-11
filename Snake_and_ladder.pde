PImage bg;

PVector[] map = new PVector[36]; 
PVector[] SnakeLadder = new PVector[10];
ArrayList<player> player_list = new ArrayList<player>();

boolean game_start = false;
boolean on_button = false;
boolean in_animation = false;
boolean is_rolled = false;
boolean is_win = false;



int number_of_player = 2;
int player_turn = 0;
int dice = 0;

color[] colors = new color[4];

int player_to_move = 0;
int first_point = 0;
int next_point = 0;



public class player{
    public float x;
    public float y;
    public int r;
    public color p_color;
    public int cur_path;
}

void setup_colors(){
    colors[0] = color(45,94,255); 
    colors[1] = color(255,0,29);
    colors[2] = color(146,22,255);
    colors[3] = color(255,155,73);


}


void setup_map(){
    float bridge = 800/6;
    float half_bridge = 800/12;
    
    
    int x = 0;
    int y = 0;
    int index = 0;
    while (y < 6){
        
        if (y%2 == 0){
            
            while (x<6){
                index = y*6 + x;
                map[index] = new PVector(bridge*x + half_bridge, 800 - y*bridge - half_bridge); 
                x++;
            }
        }
        else{
            while (x<6){
                index =6*y + x;
                map[index] = new PVector(800 - x*bridge - half_bridge, 800 - y*bridge - half_bridge); 

                x++;
            }
        }

        x = 0;
        y++;
    }
    
    // int i = 0;
    // while (i < 36){

    //     println(i+1, map[i].x,map[i].y);
    //     if ((i+1) %6 == 0){
    //         println("----------");
    //     }

    //     i++;
    // }
}
void setup_SnakeLadder(){
    SnakeLadder[0] = new PVector(5,17);
    SnakeLadder[1] = new PVector(10,13);
    SnakeLadder[2] = new PVector(14,21);
    SnakeLadder[3] = new PVector(20,27);
    SnakeLadder[4] = new PVector(22,34);
    SnakeLadder[5] = new PVector(30,19);
    SnakeLadder[6] = new PVector(33,21);
    SnakeLadder[7] = new PVector(24,11);
    SnakeLadder[8] = new PVector(19,4);
    SnakeLadder[9] = new PVector(15,1);

} 


void setup() {
    surface.setTitle("Snake and ladder");
    size(1000,800);
    bg = loadImage("Map.jpg");
    setup_map();
    setup_colors();
    setup_SnakeLadder();
    // frameRate(200);

}


void game_graphics(){
    background(153,255,161);
    if (is_win){
        strokeWeight(3);
        textSize(200);
        fill(colors[player_turn]);
        text("P"+ str(player_turn+1) + " win", 230, 440);
        return;
    }

    
    
    
    
    image(bg,0,0,800,800);
    stroke(0);
    noFill();
    strokeWeight(3);
    rect(801,1,198,798);
    on_button = false;
    

    if  (!game_start){
        textSize(20);
        strokeWeight(2);
        fill(0);
        text("Number of players",825,30);
        

        // draw the increase button
        if((850 < mouseX && mouseX < 850 + 100) && (45 < mouseY && mouseY < 45+50)){
            fill(105,192,198);
            on_button = true;

        }
        else{
            fill(135,245,255);
        }
        rect(850,45,100,50,10,10,10,10);
        fill(0);

        triangle(900, 55, 900 - 20, 85 , 900 + 20, 85);
        //        x1  y1     x2     y2      x3     y3
        // draw the display number frame
        fill(135,245,255);
        rect(850,110,100,100,10,10,10,10);
        textSize(100);
        strokeWeight(2);
        fill(0);
        text(str(number_of_player),875,193);


        // draw the decrease button
        if((850 < mouseX && mouseX < 850 + 100) && (225 < mouseY && mouseY < 225+50)){
            fill(105,192,198);
            on_button = true;

        }
        else{
            fill(135,245,255);
        }
        rect(850,225,100,50,10,10,10,10);
        fill(0);
        triangle(900,265,900-20,235,900+20,235);

        
        //draw the start button
        if((830 < mouseX && mouseX < 830 + 140) && (320 < mouseY && mouseY < 320+60)){
            fill(105,192,198);
            on_button = true;
            
        }
        else{
            fill(135,245,255);
        }
        rect(830,320,140,60,10,10,10,10);

        textSize(50);
        strokeWeight(2);
        fill(0);
        text("Start",848,367);

        noFill();
        rect(810,420,180,370,10,10,10,10);

        textSize(25);
        strokeWeight(2);
        fill(0);
        text("Author: ",820,450);
        text("Vu Khoi Nguyen ",820,480);

        text("Discord: ",820,520);
        text("aoikanariya",820,550);

        text("If there is any ",820,600);
        text("bug, please",820,630);
        text("contact me.",820,660);
        text("Thank you!",820,690);


        text("Enjoy :D",820,750);

    }
    else{
        fill(255);
        rect(810,10,180,180,10,10,10,10);
        textSize(150);
        strokeWeight(2);
        fill(colors[player_turn]);
        text("P" + str(player_turn + 1),820,150);
        


        for (int i = 0; i < number_of_player;i++){
            player current_player = player_list.get(i);
            fill(current_player.p_color);
            strokeWeight(3);
            stroke(255);
            circle(current_player.x,current_player.y,current_player.r);
        }

        fill(255);
        strokeWeight(3);
        stroke(0);
        rect(840,200,120,120,10,10,10,10);
        String dice_text = new String();

        if (dice == 0){
            dice_text = "?";
        }
        else{
            dice_text = str(dice);
        }

        textSize(120);
        strokeWeight(2);
        fill(colors[player_turn]);
        text(dice_text, 875, 300);

        
        //if there is animation, then no button is displayed
        if (!in_animation){
        
            if(!is_rolled){
                if((820 < mouseX && mouseX < 820 + 160) && (340 < mouseY && mouseY < 340+60)){
                    fill(105,192,198);
                    on_button = true;
                }
                else{
                    fill(135,245,255);
                }
                rect(820,340,160,60,10,10,10,10);
                textSize(28);
                strokeWeight(2);
                fill(0);
                text("Roll the dice",828,378);
            }

            // if dice is zero, then can't press move button
            if (dice != 0){

                
                // draw the move forward button
                if((820 < mouseX && mouseX < 820 + 160) && (500 < mouseY && mouseY < 500+60)){
                    fill(105,192,198);
                    on_button = true;    
                }
                else{
                    fill(135,245,255);
                }
                rect(820,500,160,60,10,10,10,10);
                textSize(25);
                strokeWeight(2);
                fill(0);
                text("Move forward",828,538);
                
                // draw the move backward button
                if((820 < mouseX && mouseX < 820 + 160) && (610 < mouseY && mouseY < 610+60)){
                    fill(105,192,198);
                    on_button = true;    
                }
                else{
                    fill(135,245,255);
                }
                rect(820,610,160,60,10,10,10,10);
                textSize(25);
                strokeWeight(2);
                fill(0);
                text("Push 1P back",828,648);
            }

        }



    }

    println(on_button);
    //change the cursor
    if (on_button){
        cursor(HAND);
    }
    else{
        cursor(ARROW);
    }
    
        
}




void setup_button_logic(){
    if (mouseButton != LEFT){return;} // if left mouse is not clicked, stop the function
    
    if((850 < mouseX && mouseX < 850 + 100) && (45 < mouseY && mouseY < 45+50)){
        number_of_player++;
        if (number_of_player > 4){
            number_of_player = 4;
        }
    }

    if((850 < mouseX && mouseX < 850 + 100) && (225 < mouseY && mouseY < 225+50)){
        number_of_player--;
        if (number_of_player<2){
            number_of_player = 2;
        }
    }
        
    if((830 < mouseX && mouseX < 830 + 140) && (320 < mouseY && mouseY < 320+60)){
        game_start = true;
        
        for(int i = 0; i < number_of_player;i++){
            


        // public class player{
        // public float x;
        // public float y;
        // public int r;
        // public color p_color;
        // public int cur_path;
        // }
            player current_player = new player();
            current_player.cur_path = 0;
            current_player.p_color = colors[i];
            current_player.x = map[0].x ;
            current_player.y = map[0].y ;
            current_player.r = 50;
            player_list.add(current_player);


        }
        adjust_player_position();

    }


}

void move_player(){
    in_animation = true;
    println(first_point);
    println(next_point);
    for(int i = 0; i < abs(first_point-next_point); i++){
        if (next_point > first_point){
            
            player_list.get(player_to_move).cur_path = player_list.get(player_to_move).cur_path + 1;
            if(player_list.get(player_to_move).cur_path > 35){
                player_list.get(player_to_move).cur_path = 35;
                is_win = true;
                player_turn = player_to_move;
                adjust_player_position();
                return;
            }

        
        }
        else{
            player_list.get(player_to_move).cur_path = player_list.get(player_to_move).cur_path - 1;
            if(player_list.get(player_to_move).cur_path < 0){
                player_list.get(player_to_move).cur_path = 0;
                adjust_player_position();
                break;
            }

        }
        adjust_player_position();

        delay(300);
    }

    
    for(int i = 0; i < 10;i++){
        if (player_list.get(player_to_move).cur_path == (int)SnakeLadder[i].x){
            // println(SnakeLadder[i].x);

            first_point = (int)SnakeLadder[i].x;
            next_point = (int)SnakeLadder[i].y;
            for(int j = 0; j < abs(first_point-next_point); j++){
                if (next_point > first_point){
                    player_list.get(player_to_move).cur_path = player_list.get(player_to_move).cur_path + 1;
                }
                else{
                    player_list.get(player_to_move).cur_path = player_list.get(player_to_move).cur_path - 1;
                }

                delay(200);
                adjust_player_position();
            }
            break;
        }
    }



    in_animation = false;
    dice = 0;
    next_turn();

}

void roll_the_dice(){
    in_animation = true;
    is_rolled = true;
    for(int i = 0;i < 9; i++){
        dice = (int)random(1,7);
        delay(150);
    }
    in_animation = false;
}


void next_turn(){
    player_turn ++;
    if (player_turn > number_of_player-1){
        player_turn = 0;
    }
    is_rolled = false;
}


void game_button_logic(){
    if (mouseButton != LEFT){return;} // if left mouse is not clicked, stop the function
    cursor(ARROW);


    if (is_win){return;} // if there is 1 player win the game, then buttons no longer function
    //if there is animation, then can't press button
    if (in_animation){return;}

    if((820 < mouseX && mouseX < 820 + 160) && (340 < mouseY && mouseY < 340+60)){
        if (!is_rolled){
            thread("roll_the_dice");
        }
    }


    if (dice == 0){return;}
    if((820 < mouseX && mouseX < 820 + 160) && (500 < mouseY && mouseY < 500+60)){
        player_to_move = player_turn;
        first_point = player_list.get(player_to_move).cur_path;
        next_point = first_point + dice;
        
        thread("move_player");

    }

    if((820 < mouseX && mouseX < 820 + 160) && (610 < mouseY && mouseY < 610+60)){

        while (true){
            player_to_move = (int) random(0,number_of_player);
            if (player_to_move != player_turn){
                break;
            }
        }        

        first_point = player_list.get(player_to_move).cur_path;
        next_point = first_point - dice;



        thread("move_player");
    }
    
}


void adjust_player_position(){
    int cur_path;
    for(int i = 0; i < number_of_player; i ++){
        
        if ( i == 0 ){
            cur_path = player_list.get(i).cur_path;
            player_list.get(i).x = map[cur_path].x - 30;
            player_list.get(i).y = map[cur_path].y - 30;
        }

        else if ( i == 1 ){
            cur_path = player_list.get(i).cur_path;
            player_list.get(i).x = map[cur_path].x + 30;
            player_list.get(i).y = map[cur_path].y + 30;
        }

        else if ( i == 2 ){
            cur_path = player_list.get(i).cur_path;
            player_list.get(i).x = map[cur_path].x - 30;
            player_list.get(i).y = map[cur_path].y + 30;
        }

        else if ( i == 3 ){
            cur_path = player_list.get(i).cur_path;
            player_list.get(i).x = map[cur_path].x + 30;
            player_list.get(i).y = map[cur_path].y - 30;
        }
    }


    if (number_of_player == 3 ){
        cur_path = player_list.get(0).cur_path;
        player_list.get(0).x = map[cur_path].x;
        player_list.get(0).y = map[cur_path].y - 24;
    } 

}

void mousePressed(){
    if (!game_start){
        setup_button_logic();
    }
    else{
        game_button_logic();
    }

}


void draw() {
    game_graphics();

}