/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


/**
 *
 * @author Kwan
 */
public class Task4Soldier extends Soldier{
    protected int coins;
    protected int defence;
    
    public Task4Soldier(){
        super();
        this.coins = 0;
        this.defence = 0;
    }
    
    public int getCoins(){
        return this.coins;
    }
    
    public void addCoins(){
        this.coins += 1;
    }
    
    public void useCoins(int price){
        this.coins -= price;
    }
    
    public void addDefence(){
        this.defence += 5;
    }
    
    public void displayInformation(){
        super.displayInformation();
        System.out.printf("Defence: %d.%n", this.defence);
        System.out.printf("Coins: %d.%n", this.coins);
    }
    
    public boolean loseHealth(){
        super.loseHealth();
        if (this.defence>10){
            this.health += 10;
            this.defence -=10;
        }else{
            this.health += this.defence;
            this.defence = 0;
        }
        return this.health<=0;
    }
        
    
}
