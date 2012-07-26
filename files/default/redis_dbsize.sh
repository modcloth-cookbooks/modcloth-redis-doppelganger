#!/bin/env bash
redis-cli dbsize |cut -f1
