// CSCI3180 Principles of Programming Languages
//
// --- Declaration ---
// I declare that the assignment here submitted is original except for source material explicitly
// acknowledged. I also acknowledge that I am aware of University policy and regulations on
// honesty in academic work, and of the disciplinary guidelines and procedures applicable to
// breaches of such policy and regulations, as contained in the website
// http://www.cuhk.edu.hk/policy/academichonesty/
//
// Assignment 3
// Name:
// Student ID:
// Email Addr:

#include <string>
#include <iostream>
using namespace std;

int creditLimit = 5000;

int repayment(string name, int balance, int repayAmt) {
    cout << "\n... Repaying debts ...\n";
    cout << "Thank you, " << name << "! ";
    balance -= repayAmt;
    cout << "You have just repayed [HKD " << repayAmt << "]!\n";
    int currentLimit = creditLimit - balance;
    cout << "Now your remaining credit limit is [HKD " << currentLimit << "].\n";
    return balance;
}

int payment(string name, int balance, int payAmt) {
    cout << "\n... Consumption payment (Luk Card) ...\n";
    int currentLimit = creditLimit - balance;
    if(currentLimit < payAmt) {
        cout << "You have exceeded your credit limit!\n";
        return -1;
    }
    currentLimit -= payAmt;
    balance += payAmt;
    cout << "You have just payed a [HKD " << payAmt << "] consumption!\n";
    cout << "Now your remaining credit limit is [HKD " << currentLimit << "].\n";
    return balance;
}

void regularClient(string name, int balance, int repayAmt, int payAmt) {
    balance = repayment(name, balance, repayAmt);
    if(balance >= 0) cout << "[Current card balance: HKD " << balance << "]\n";
    else cout << "ERROR! You are trying to repay more than your debt amount!\n";
    balance = payment(name, balance, payAmt);
    if(balance >= 0) cout << "[Current card balance: HKD " << balance << "]\n";
    else cout << "ERROR! You are trying to pay beyond your credit limit!\n";
}

void premierClient(string name, int balance, int repayAmt, int payAmt) {
    int creditLimit = 10000;
    cout << "Dear Premier client " << name << ", you have a credit limit of [HKD " << creditLimit << "]! Enjoy!\n";
    regularClient(name, balance, repayAmt, payAmt);
}

void bank(string name, string ID, int balance, int repayAmt, int payAmt) {
    cout << "\n** Welcome " << name << " **\n";
    cout << "[Your credit card balance: HKD " << balance << "]\n";
    if(ID[0] == 'p') premierClient(name, balance, repayAmt, payAmt);
    else regularClient(name, balance, repayAmt, payAmt);
}

int main() {
    cout << "\t\t### Welcome to the CU Bank ###\n";
    bank("Alice", "r123", 2000, 1000, 3000);
    bank("Bob",   "p456", 5000, 2000, 7000);
    bank("Carol", "r789", 5000, 2000, 7000);
    return 0;
}


