#ifndef TIMER_H
#define TIMER_H

extern int loops;
extern int int_flag;

void setupTimer1(uint16_t period);

void setupTimer2(uint16_t period);

void stopTimer1(void);

void stopTimer2(void);

#endif
