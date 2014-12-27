//////////////////////////////////////////////
// File: processPattern.c
// Description: 读入一段文字，拆出 时间 or 金额，剩下的文字做分类
// Author: Phantom Weng
// Date: 2014/11/27
//
//

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "dictType.h"
#include "dictList.h"

#define MAX_INPUT_LEN           1024

#define SUCCESS                 0
#define ERROR                   -1

#define INPUT_FILE              "input.txt"

//#define debug_printf            printf
#define debug_printf            

int g_nDateOffset = 0;
int g_nTime = 0;
int g_nMoney = 0;
char g_szType[MAX_INPUT_LEN];
char g_szRemain[MAX_INPUT_LEN];

int getMinute(char *pCh)
{
    int num=0,nLastDigit=0;
    char *pChStart=pCh;

    debug_printf("in getMinute, pCh=[%s]\n",pCh);

    if (pCh == NULL)
        return 0;
    
    if (*pCh >= '1' && *pCh <= '9')
    {
        num = *pCh - '0';
        pCh++;
        if (*pCh >= '0' && *pCh <= '9') {
            num = num * 10 + (*pCh - '0');
            pCh++;
        }
        if (pCh && strncmp(pCh,"分钟",6)==0) {
            strcpy(pChStart,pCh+6);
            return num;
        }
        else if (pCh && strncmp(pCh,"分",3)==0) {
            strcpy(pChStart,pCh+3);
            return num;
        }
        else if (pCh && strncmp(pCh,"刻钟",6)==0) {
            strcpy(pChStart,pCh+6);
            return num*15;
        }
    }

    if (strncmp(pCh,"一",3) == 0 || strncmp(pCh,"二",3) == 0 || strncmp(pCh,"三",3) == 0 ||
        strncmp(pCh,"四",3) == 0 || strncmp(pCh,"五",3) == 0 || strncmp(pCh,"六",3) == 0 ||
        strncmp(pCh,"七",3) == 0 || strncmp(pCh,"八",3) == 0 || strncmp(pCh,"九",3) == 0 ||
        strncmp(pCh,"两",3) == 0 || strncmp(pCh,"十",3) == 0) {
        if (strncmp(pCh,"一",3) == 0)
            nLastDigit = 1;
        else if (strncmp(pCh,"二",3) == 0)
            nLastDigit = 2;
        else if (strncmp(pCh,"三",3) == 0)
            nLastDigit = 3;
        else if (strncmp(pCh,"四",3) == 0)
            nLastDigit = 4;
        else if (strncmp(pCh,"五",3) == 0)
            nLastDigit = 5;
        else if (strncmp(pCh,"六",3) == 0)
            nLastDigit = 6;
        else if (strncmp(pCh,"七",3) == 0)
            nLastDigit = 7;
        else if (strncmp(pCh,"八",3) == 0)
            nLastDigit = 8;
        else if (strncmp(pCh,"九",3) == 0)
            nLastDigit = 9;
        else if (strncmp(pCh,"两",3) == 0)
            nLastDigit = 2;
        else if (strncmp(pCh,"十",3) == 0)
            nLastDigit = 10;
        pCh = pCh + 3;
            
        if (strncmp(pCh,"十",3) == 0) {
            nLastDigit = nLastDigit * 10;
            pCh = pCh + 3;
        }

        if (strncmp(pCh,"一",3) == 0)
            nLastDigit += 1;
        else if (strncmp(pCh,"二",3) == 0)
            nLastDigit += 2;
        else if (strncmp(pCh,"三",3) == 0)
            nLastDigit += 3;
        else if (strncmp(pCh,"四",3) == 0)
            nLastDigit += 4;
        else if (strncmp(pCh,"五",3) == 0)
            nLastDigit += 5;
        else if (strncmp(pCh,"六",3) == 0)
            nLastDigit += 6;
        else if (strncmp(pCh,"七",3) == 0)
            nLastDigit += 7;
        else if (strncmp(pCh,"八",3) == 0)
            nLastDigit += 8;
        else if (strncmp(pCh,"九",3) == 0)
            nLastDigit += 9;
        else if (strncmp(pCh,"两",3) == 0)
            nLastDigit += 2;
        else
            pCh = pCh - 3; // 先减三, 反正等等要加回来
        pCh = pCh + 3;

        if (pCh && strncmp(pCh,"分钟",6)==0) {
            strcpy(pChStart,pCh+6);
            return nLastDigit;
        }
        else if (pCh && strncmp(pCh,"分",3)==0) {
            strcpy(pChStart,pCh+3);
            return nLastDigit;
        }
        else if (pCh && strncmp(pCh,"刻钟",6)==0) {
            strcpy(pChStart,pCh+6);
            return nLastDigit*15;
        }
    }        
    return 0;
} // end of getMinute(char *p)

int process(char szParam[MAX_INPUT_LEN])
{
    char *pCh=NULL,*pChStart=NULL;
    char szInput[MAX_INPUT_LEN];
    int nTemp=0,nLastDigit=0,nLastQuant=0,nZeroFlag=0,nLastIsTen=0;
    float fTemp=0,fLastQuant=0;
    int nLen=0,i;

    strncpy(szInput,szParam,MAX_INPUT_LEN-1);
    szInput[MAX_INPUT_LEN-1] = '\0';
    g_nTime = 0;
    g_nMoney = 0;

    // 1. condense (去掉空白), 目前先不做
    debug_printf("Input [%s]\n",szInput);

    // 2. 昨天, 前天
    if ((pCh=strstr(szInput,"昨天")) != NULL) {
        strcpy(pCh,pCh+6);
        g_nDateOffset = 1;
    }
    else if ((pCh=strstr(szInput,"前天")) != NULL) {
        strcpy(pCh,pCh+6);
        g_nDateOffset = 2;
    }
    else if ((pCh=strstr(szInput,"今天")) != NULL) {
        strcpy(pCh,pCh+6);
        g_nDateOffset = 0;
    }
    else
        g_nDateOffset = 0;

    if ((pCh=strstr(szInput,"早上")) != NULL) {
        strcpy(pCh,pCh+6);
    }
    if ((pCh=strstr(szInput,"上午")) != NULL) {
        strcpy(pCh,pCh+6);
    }
    if ((pCh=strstr(szInput,"中午")) != NULL) {
        strcpy(pCh,pCh+6);
    }
    if ((pCh=strstr(szInput,"下午")) != NULL) {
        strcpy(pCh,pCh+6);
    }
    if ((pCh=strstr(szInput,"清晨")) != NULL) {
        strcpy(pCh,pCh+6);
    }
    if ((pCh=strstr(szInput,"傍晚")) != NULL) {
        strcpy(pCh,pCh+6);
    }
    if ((pCh=strstr(szInput,"晚上")) != NULL) {
        strcpy(pCh,pCh+6);
    }
    if ((pCh=strstr(szInput,"半夜")) != NULL) {
        strcpy(pCh,pCh+6);
    }
    if ((pCh=strstr(szInput,"黄昏")) != NULL) {
        strcpy(pCh,pCh+6);
    }
    if ((pCh=strstr(szInput,"的时候")) != NULL) {
        strcpy(pCh,pCh+9);
    }
    debug_printf("After date trim, [%s]\n",szInput);

    // 3. 去掉 "我"
    if ((pCh=strstr(szInput,"我")) != NULL) {
        strcpy(pCh,pCh+3);
    }
    debug_printf("After 我 trim, [%s]\n",szInput);

    ///////////////////////////////////////////////////
    // 4. 一个一个字看过去, 使用 finite state machine
    ///////////////////////////////////////////////////
    pCh = szInput;
    while(*pCh != '\0') {
        // 4.1
        if (strncmp(pCh,"半",3) == 0) {
            if (strncmp(pCh+3,"天",3) == 0) {
                g_nTime = 240;
                strcpy(pCh,pCh+6);
                debug_printf("半天 - [%s]\n",szInput);
                nTemp = 240;
                break;
            }
            else if (strncmp(pCh+3,"个小时",9) == 0) {
                g_nTime = 30;
                strcpy(pCh,pCh+12);
                debug_printf("半个小时 - [%s]\n",szInput);
                nTemp = 30;
                break;
            }
            else if (strncmp(pCh+3,"小时",6) == 0) {
                g_nTime = 30;
                strcpy(pCh,pCh+9);
                debug_printf("半小时 = [%s]\n",szInput);
                nTemp = 30;
                break;
            }
            pCh = pCh+3;
        }

        // 4.2
        if (strncmp(pCh,"一天",6) == 0) {
            g_nTime = 480;
            strcpy(pCh,pCh+6);
            debug_printf("一天 - [%s]\n",szInput);
            nTemp = 480;
            break;
        }
        else if (strncmp(pCh,"整天",6) == 0) {
            g_nTime = 480;
            strcpy(pCh,pCh+6);
            debug_printf("一天 - [%s]\n",szInput);
            nTemp = 480;
            break;
        }

        // 4.3
        if (*pCh >= '0' && *pCh <= '9') {
            // [0-9]+
            pChStart = pCh;
            nTemp = *pCh - '0';
            pCh ++;
            while (*pCh >= '0' && *pCh <= '9') {
                nTemp = nTemp * 10;
                nTemp = nTemp + (*pCh - '0');
                pCh ++;
            }
            // 处理小数点, 先转换 nTemp => fTemp, 再转换 fTemp => nTemp
            if (*pCh == '.') {
                fTemp = nTemp;
                // 拿 fLastQuant 来计算小数目前为数
                fLastQuant = 0.1;
                pCh ++;
                while (*pCh >= '0' && *pCh <= '9') {
                    fTemp += (fLastQuant * (*pCh - '0'));
                    fLastQuant /= 10;
                    pCh ++;
                }
                nTemp = fTemp;
            }
            else
                fTemp = 0;

step_X1:
            if (strncmp(pCh,"元",3) == 0 || (strncmp(pCh,"块",3) == 0)) {
                g_nMoney = nTemp;
                strcpy(pChStart,pCh+3);
                pCh = pChStart;
                debug_printf("xx元 - [%s]\n",szInput);
                break;
            }
            else if (strncmp(pCh,"小时",6) == 0) {
                if (fTemp > 0)
                    g_nTime = fTemp * 60;
                else
                    g_nTime = nTemp * 60;
                strcpy(pChStart,pCh+6);
                pCh = pChStart;
                debug_printf("xx小时 - [%s]\n",szInput);
                // 准备处理 x个小时x分钟/刻钟
                // 个小时后面如果接数字 or 文字 (反正顶多是几十 or 个位数)
                // 直接在这边硬干就好
                // 跳过【又】, 跳过【零】
                if (pCh && ((strncmp(pCh,"又",3) == 0) || (strncmp(pCh,"零",3) == 0))) {
                    strcpy(pChStart,pCh+3);
                    pCh = pChStart;
                    //pCh = pCh+3;
                }
                g_nTime += getMinute(pCh);
                break;
            }
            else if (strncmp(pCh,"分钟",6) == 0) {
                g_nTime = nTemp;
                strcpy(pChStart,pCh+6);
                pCh = pChStart;
                debug_printf("xx分钟 - [%s]\n",szInput);
                break;
            }
            else if (strncmp(pCh,"分",3) == 0) {
                g_nTime = nTemp;
                strcpy(pChStart,pCh+3);
                pCh = pChStart;
                debug_printf("xx分 - [%s]\n",szInput);
                break;
            }
            else if (strncmp(pCh,"刻钟",6) == 0) {
                if (fTemp > 0)
                    g_nTime = fTemp * 15;
                else
                    g_nTime = nTemp * 15;
                strcpy(pChStart,pCh+6);
                pCh = pChStart;
                debug_printf("xx刻钟 - [%s]\n",szInput);
                break;
            }
            else if (strncmp(pCh,"个小时半",12) == 0) {
                g_nTime = nTemp * 60 + 30;
                strcpy(pChStart,pCh+12);
                pCh = pChStart;
                debug_printf("xx个半小时 - [%s]\n",szInput);
                break;
            }
            else if (strncmp(pCh,"个小时",9) == 0) {
                if (fTemp > 0)
                    g_nTime = fTemp * 60;
                else
                    g_nTime = nTemp * 60;
                strcpy(pChStart,pCh+9);
                pCh = pChStart;
                debug_printf("xx个小时 - [%s], g_nTime=[%d]\n",szInput,g_nTime);
                // 准备处理 x个小时x分钟/刻钟
                // 个小时后面如果接数字 or 文字 (反正顶多是几十 or 个位数)
                // 直接在这边硬干就好
                g_nTime += getMinute(pCh);
                break;
            }
            else if (strncmp(pCh,"个半小时",12) == 0) {
                g_nTime = nTemp * 60 + 30;
                strcpy(pChStart,pCh+12);
                pCh = pChStart;
                debug_printf("xx个半小时 - [%s]\n",szInput);
                break;
            }
            else { //前面是 "花费", "花", "花了", "用了", "买"(TODO)
                debug_printf("*** pChStart=[%s],pCh=[%s],\n",pChStart,pCh);
                if (pChStart-szInput >= 6 && 
                    (strncmp(pChStart-6,"花费",6) == 0 || 
                     strncmp(pChStart-6,"花了",6) == 0 ||
                     strncmp(pChStart-6,"用了",6) == 0)) {
                    g_nMoney = nTemp;
                    strcpy(pChStart-6,pCh);
                    pCh = pChStart-6;
                    break;
                }
                else if (pChStart-szInput >= 7 && 
                    (strncmp(pChStart-7,"花费",6) == 0 || 
                     strncmp(pChStart-7,"花了",6) == 0 ||
                     strncmp(pChStart-7,"用了",6) == 0)) {
                    g_nMoney = nTemp;
                    strcpy(pChStart-7,pCh-1);
                    pCh = pChStart-7;
                    break;
                }
                else if (pChStart-szInput >=3 && strncmp(pChStart-3,"花",3) == 0) {
                    g_nMoney = nTemp;
                    strcpy(pChStart-3,pCh);
                    pCh = pChStart-3;
                    break;
                }
            }
        } // end of 4.3 [0-9]+

        // 4.4
        nTemp = 0;
        fTemp = 0;
        fLastQuant = 0;
        nZeroFlag = 0;
        nLastDigit = 0;
        nLastQuant = 0;
        pChStart = pCh;
step_4_4:
        if (strncmp(pCh,"一",3) == 0 || strncmp(pCh,"二",3) == 0 || strncmp(pCh,"三",3) == 0 ||
            strncmp(pCh,"四",3) == 0 || strncmp(pCh,"五",3) == 0 || strncmp(pCh,"六",3) == 0 ||
            strncmp(pCh,"七",3) == 0 || strncmp(pCh,"八",3) == 0 || strncmp(pCh,"九",3) == 0 ||
            strncmp(pCh,"两",3) == 0 || strncmp(pCh,"十",3) == 0) {
            nLastIsTen = 0;
            if (strncmp(pCh,"一",3) == 0)
                nLastDigit = 1;
            else if (strncmp(pCh,"二",3) == 0)
                nLastDigit = 2;
            else if (strncmp(pCh,"三",3) == 0)
                nLastDigit = 3;
            else if (strncmp(pCh,"四",3) == 0)
                nLastDigit = 4;
            else if (strncmp(pCh,"五",3) == 0)
                nLastDigit = 5;
            else if (strncmp(pCh,"六",3) == 0)
                nLastDigit = 6;
            else if (strncmp(pCh,"七",3) == 0)
                nLastDigit = 7;
            else if (strncmp(pCh,"八",3) == 0)
                nLastDigit = 8;
            else if (strncmp(pCh,"九",3) == 0)
                nLastDigit = 9;
            else if (strncmp(pCh,"两",3) == 0)
                nLastDigit = 2;
            else if (strncmp(pCh,"十",3) == 0) {
                nLastDigit = 10;
                nLastIsTen = 1;
                nTemp += nLastDigit;
            }
            pCh = pCh + 3;

            if (fLastQuant != 0) {
                fTemp += nLastDigit * fLastQuant;
                fLastQuant /= 10;
            }
          
            // 处理 三点五 小时/分钟/刻钟
            if (strncmp(pCh,"点",3) == 0) {
                nTemp += nLastDigit;
                fTemp = nTemp;
                fLastQuant = 0.1;
                pCh = pCh + 3;
            }

            if (strncmp(pCh,"十",3) == 0) {
                nZeroFlag = 0;
                nLastDigit = nLastDigit * 10;
                nTemp += nLastDigit;
                pCh = pCh + 3;
                nLastDigit = 0;
                nLastQuant = 10;
            }
            else if (strncmp(pCh,"百",3) == 0) {
                nZeroFlag = 0;
                nLastDigit = nLastDigit * 100;
                nTemp += nLastDigit;
                pCh = pCh + 3;
                nLastDigit = 0;
                nLastQuant = 100;
            }
            else if (strncmp(pCh,"千",3) == 0) {
                nZeroFlag = 0;
                nLastDigit = nLastDigit * 1000;
                nTemp += nLastDigit;
                pCh = pCh + 3;
                nLastDigit = 0;
                nLastQuant = 1000;
            }
            else if (strncmp(pCh,"万",3) == 0) {
                nZeroFlag = 0;
                nTemp += nLastDigit;
                nTemp *= 10000;
                pCh = pCh + 3;
                nLastDigit = 0;
                nLastQuant = 10000;
            }
            else if (strncmp(pCh,"亿",3) == 0) {
                nZeroFlag = 0;
                nTemp += nLastDigit;
                nTemp *= 100000000;
                pCh = pCh + 3;
                nLastDigit = 0;
                nLastQuant = 100000000;
            }

            // 零
            if (strncmp(pCh,"零",3) == 0) {
                nZeroFlag = 1;
                pCh = pCh + 3;
            }

            goto step_4_4;
        }

        if (nTemp != 0 || nLastDigit != 0) { // 国字有找到, 且后面不再是数字
            if (nLastDigit != 0) {
                if (nZeroFlag)
                    nTemp += nLastDigit;
                else if (nLastQuant != 0)
                    nTemp += (nLastDigit * nLastQuant / 10);
                else if (nLastIsTen == 0)
                    nTemp += nLastDigit; 
            }
            goto step_X1;
        }
        pCh++;
    } // end of while(*pCh != '\0')

    // 4.5
    // 把后面的 "的" 清掉
    if (pCh && strncmp(pCh,"的",3) == 0)
        strcpy(pCh,pCh+3);

    // 还是要把 "花费", "花", "花了", "用了" 清掉
    debug_printf("pChStart=[%s],-6=[%s],-5=[%s]\n",pChStart,pChStart-6,pChStart-5);
    if (pChStart && pChStart-szInput >= 6 && 
        (strncmp(pChStart-6,"花费",6) == 0 || 
         strncmp(pChStart-6,"花了",6) == 0 ||
         strncmp(pChStart-6,"用了",6) == 0))
        strcpy(pChStart-6,pChStart);
    else if (pChStart && pChStart-szInput >= 5 && 
        (strncmp(pChStart-5,"花费",6) == 0 || 
         strncmp(pChStart-5,"花了",6) == 0 ||
         strncmp(pChStart-5,"用了",6) == 0))
        strcpy(pChStart-5,pChStart+1);
    else if (pChStart && pChStart-szInput >=3 && strncmp(pChStart-3,"花",3) == 0)
        strcpy(pChStart-3,pChStart);

    // 把前面的 "了" 清掉
    if (pChStart && pChStart-szInput >= 3 && strncmp(pChStart-3,"了",3) == 0)
        strcpy(pChStart-3,pChStart);

    // 5
    if (nTemp == 0)
        return ERROR;

    // 6. (already done)
    debug_printf("after step 6, szInput=[%s]\n",szInput);

    // 7. Find Database (TODO)

    // 8. Match dict
    nLen = sizeof(g_szDictList) / sizeof(g_szDictList[0]);
    strncpy(g_szRemain,szInput,MAX_INPUT_LEN-1);
    g_szRemain[MAX_INPUT_LEN-1] = '\0';
    for (i=0;i<nLen;i++) {
        if (strstr(szInput,g_szDictList[i]) != NULL) {
            strncpy(g_szType,g_szDictType[i],MAX_INPUT_LEN-1);
            g_szType[MAX_INPUT_LEN-1] = '\0';
            return SUCCESS;
        }
    }
   
    // 9. No match, default=生活
    strncpy(g_szType,"生活",MAX_INPUT_LEN-1);
    g_szType[MAX_INPUT_LEN-1] = '\0';
    return SUCCESS;
} // end of process()

int main(int argc, char *argv[])
{
    char *pCh=NULL;
    char szTemp[MAX_INPUT_LEN];
    int nLen=0;
    FILE *fp=NULL;

    if (argc == 2) {
        strncpy(szTemp,argv[1],MAX_INPUT_LEN-1);
        szTemp[MAX_INPUT_LEN-1] = '\0';
        if (process(szTemp) == SUCCESS)
            printf("{\"Remain\":\"%s\",\"Type\":\"%s\",\"Money\": \"%d\",\"Time\":\"%d\"}\n", 
                g_szRemain,g_szType,g_nMoney,g_nTime);
        else
            printf("{\"error\": \"代码盲区\"}\n");
    }

    if ((fp=fopen(INPUT_FILE,"r")) != NULL) {
        while(fgets(szTemp,MAX_INPUT_LEN-1,fp) != NULL) {
            //fgets(szTemp,MAX_INPUT_LEN-1,fp);
            szTemp[MAX_INPUT_LEN-1] = '\0';
            // right trim
            nLen = strlen(szTemp);
            while (szTemp[nLen-1] == '\r' || szTemp[nLen-1] == '\n') {
                szTemp[nLen-1] = '\0';
                nLen = strlen(szTemp);
            }

            if (process(szTemp) == SUCCESS)
                printf("[%s] - Remain:[%s],Type:[%s],Money:[%d],Time:[%d]\n\n", 
                        szTemp,g_szRemain,g_szType,g_nMoney,g_nTime);
            else
                printf("[%s] - process failed\n\n", szTemp);
        }
        fclose(fp);
        fp = NULL;
    }

    return 0;
} // end of main()
